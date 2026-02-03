{
  description = "fx's nix-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    jail-nix.url = "sourcehut:~alexdavid/jail.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    irssi-themes = {
      url = "github:fxttr/irssi-themes";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      ...
    }@inputs:
    let
      hbuild = pkgs.writeShellScriptBin "hbuild" ''
        #!/usr/bin/env bash
        home-manager switch --flake . $@
      '';

      nbuild = pkgs.writeShellScriptBin "nbuild" ''
        #!/usr/bin/env bash

        if [ -z ''${REMOTE+x} ]; then
          sudo nixos-rebuild switch --flake . $@
        else
          HOSTNAME=''${REMOTE}

          nixos-rebuild switch --flake . --use-remote-sudo --build-host $@ --target-host $@
        fi
      '';

      system = "x86_64-linux";

      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      lib = nixpkgs.lib;

      commonNixOSModules = host: [
        (
          { pkgs, ... }:
          {
            _module.args.jail = inputs.jail-nix.lib.init pkgs;
          }
        )
        inputs.microvm.nixosModules.host
        (import ./modules/nixos {
          inherit
            self
            inputs
            host
            lib
            ;
        })
        (import ./hosts/${host}/nixos { inherit self pkgs lib; })
        inputs.sops-nix.nixosModules.sops
      ];

      commonHomeManagerModules = user: host: [
        (
          { pkgs, ... }:
          {
            _module.args.jail = inputs.jail-nix.lib.init pkgs;
          }
        )
        (import ./modules/home-manager {
          inherit
            pkgs
            self
            inputs
            host
            user
            ;
        })
        ./hosts/${host}/home-manager
        inputs.sops-nix.homeManagerModules.sops
      ];

      commonMicroVMModules = name: [
        inputs.microvm.nixosModules.microvm
        ./microvms/${name}
      ];

      mkSystem =
        name: cfg:
        nixpkgs.lib.nixosSystem {
          system = cfg.system or "x86_64-linux";

          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
            overlays = (
              builtins.map (
                name:
                (prev: super: {
                  ${name} = self.nixosConfigurations.${name}.config.microvm.declaredRunner;
                })
              ) (cfg.microvms or [ ])
            );
          };

          modules = (commonNixOSModules name) ++ (cfg.modules or [ ]);

          specialArgs = { inherit inputs; };
        };

      mkHomeManager =
        name: cfg:
        let
          namePair = nixpkgs.lib.match "^(.*)@(.*)$" name;
          user = nixpkgs.lib.elemAt namePair 0;
          host = nixpkgs.lib.elemAt namePair 1;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = (commonHomeManagerModules user host) ++ (cfg.modules or [ ]);

          extraSpecialArgs = { inherit inputs; };
        };

      mkMicroVM =
        name: cfg:
        nixpkgs.lib.nixosSystem {
          system = cfg.system or "x86_64-linux";

          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
            overlays = [
              inputs.microvm.overlays.default
            ];
          };

          modules = (commonMicroVMModules name) ++ (cfg.modules or [ ]);

          specialArgs = { inherit self; };
        };

      systems = {
        microvms = {
          www = { };
          devel = { };
        };

        nixos = {
          hadron = {
            microvms = [
              "www"
              "devel"
            ];
          };

          lepton = {

          };
        };

        homes = {
          "marrero@hadron" = { };

          "marrero@lepton" = { };
        };
      };
    in
    {
      nixosConfigurations =
        (nixpkgs.lib.mapAttrs mkSystem systems.nixos) // (nixpkgs.lib.mapAttrs mkMicroVM systems.microvms);

      homeConfigurations = nixpkgs.lib.mapAttrs mkHomeManager systems.homes;

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          hbuild
          nbuild
          sops
          nixfmt
          nixfmt-tree
        ];
      };
    };
}
