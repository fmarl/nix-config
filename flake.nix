{
  description = "fx's nix-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    code-nix = {
      url = "github:fxttr/code-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        extensions.follows = "nix-vscode-extensions";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swm = {
      url = "github:fxttr/swm";
    };

    stc = {
      url = "github:fxttr/stc";
    };

    irssi-themes = {
      url = "github:fxttr/irssi-themes";
      flake = false;
    };

    media = {
      url = "github:fxttr/media";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs:
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

      pkgs =
        import inputs.nixpkgs
          {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };

      customNixpkgs = ({
        nixpkgs.overlays = [
          (final: prev: { swm = inputs.swm.defaultPackage.${system}; })
          (final: prev: { stc = inputs.stc.defaultPackage.${system}; })
        ];
      });

      commonNixOSModules = host: [
        (import ./modules/nixos {
          inherit self inputs host;
        })
        customNixpkgs
        ./hosts/${host}/nixos
        inputs.sops-nix.nixosModules.sops
      ];

      commonHomeManagerModules = user: host: [
        (import ./modules/home-manager {
          inherit pkgs self inputs host user;
        })
        customNixpkgs
        ./hosts/${host}/home-manager
        inputs.sops-nix.homeManagerModules.sops
      ];

      mkSystem = name: cfg: nixpkgs.lib.nixosSystem {
        inherit pkgs;

        system = cfg.system or "x86_64-linux";

        modules = (commonNixOSModules name) ++ (cfg.modules or [ ]);

        specialArgs = { inherit inputs; };
      };

      mkHomeManager = name: cfg:
        let
          system = cfg.system or "x86_64-linux";
          namePair = nixpkgs.lib.match "^(.*)@(.*)$" name;
          user = nixpkgs.lib.elemAt namePair 0;
          host = nixpkgs.lib.elemAt namePair 1;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = (commonHomeManagerModules user host) ++ (cfg.modules or [ ]);

          extraSpecialArgs = { inherit inputs; };
        };

      systems = {
        nixos = {
          workstation = { };

          ntb = { };

          lab = { };
        };

        homes = {
          "marrero@workstation" = { };

          "marrero@ntb" = { };
        };
      };

      code = inputs.code-nix.packages.${system}.default;
    in
    {
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      };

      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems.nixos;

      homeConfigurations = nixpkgs.lib.mapAttrs mkHomeManager systems.homes;

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nixpkgs-fmt
          hbuild
          nbuild
          sops
          (code {
            profiles.nix.enable = true;
          })
        ];
      };
    };
}
