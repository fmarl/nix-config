{
  description = "fx's nix-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    edinix = {
      url = "github:fmarl/edinix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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
      edinix,
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

      commonNixOSModules = host: [
        (import ./modules/nixos { inherit self inputs host; })
        ./hosts/${host}/nixos
        inputs.sops-nix.nixosModules.sops
      ];

      commonHomeManagerModules = user: host: [
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

      mkSystem =
        name: cfg:
        nixpkgs.lib.nixosSystem {
          inherit pkgs;

          system = cfg.system or "x86_64-linux";

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

      systems = {
        nixos = {
          workstation = { };

          ntb = {
            modules = [ inputs.impermanence.nixosModules.impermanence ];
          };
        };

        homes = {
          "marrero@workstation" = { };

          "marrero@ntb" = { };

          "marrero@lg-etl-prd" = { };
        };
      };

      helix = edinix.helix.${system} {
        profiles.nix.enable = true;
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems.nixos;

      homeConfigurations = nixpkgs.lib.mapAttrs mkHomeManager systems.homes;

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          hbuild
          nbuild
          sops
          helix.editor
          helix.tooling
        ];
      };
    };
}
