{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-code.url = "github:fxttr/nix-code";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-cfg = {
      url = "github:fxttr/emacs-cfg";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "github:fxttr/secrets";
      flake = false;
    };

    coco = {
      url = "github:fxttr/coco";
    };

    media = {
      url = "github:foxt/macOS-Wallpapers";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs:
        let
          hbuild = legacyPackages.writeShellScriptBin "hbuild" ''
            #!/usr/bin/env bash
            home-manager switch --flake . $@
          '';

          nbuild = legacyPackages.writeShellScriptBin "nbuild" ''
            #!/usr/bin/env bash
            sudo nixos-rebuild switch --flake . $@
          '';

          system = "x86_64-linux";

          legacyPackages = 
            import inputs.nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };

          extensions = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;

          commonNixOSModules = name: [
            {
              nix = {
                gc = {
                  automatic = true;
                  dates = "weekly";
                };

                settings = {
                  trusted-users = [ "root" "marrero" ];
                  allowed-users = [ "@wheel" ];
                };

                extraOptions = "experimental-features = nix-command flakes";

                optimise.automatic = true;
              };

              networking.hostName = name;
            }
            ./hosts/${name}/nixos/configuration.nix
            inputs.sops-nix.nixosModules.sops
            inputs.coco.nixosModules.nixos
          ];

          commonHomeManagerModules = name: [
            ./hosts/${name}/home-manager/home.nix
            inputs.coco.nixosModules.home-manager
            inputs.sops-nix.homeManagerModules.sops
          ];

          mkSystem = name: cfg: nixpkgs.lib.nixosSystem {
            system = cfg.system or "x86_64-linux";

            pkgs = import inputs.nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };

            modules = (commonNixOSModules name) ++ (cfg.modules or []);

            specialArgs = { inherit inputs; };
          };

          mkHomeManager = name: cfg: 
            let
              system = cfg.system or "x86_64-linux";
              namePair = nixpkgs.lib.match "^(.*)@(.*)$" name;
            in home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };

              modules = (commonHomeManagerModules (nixpkgs.lib.elemAt namePair 1)) ++ (cfg.modules or []);

              extraSpecialArgs = { inherit inputs; };
            };

          systems = {
            nixos = {
              workstation = {};

              ntb = {};
            };

            homes = {
              "marrero@workstation" = {};

              "marrero@ntb" = {};
            };
          };
        in
        {
          nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems.nixos;

          homeConfigurations = nixpkgs.lib.mapAttrs mkHomeManager systems.homes;

          devShells.${system}.default = legacyPackages.mkShell {
            nativeBuildInputs = with legacyPackages; [
              nixpkgs-fmt
              hbuild
              nbuild
              (inputs.nix-code.packages.${system}.default {
                extensions = [
                  extensions.bbenoist.nix
                  extensions.mkhl.direnv
                ];

                userDir = "$HOME/.vscode/${self}";
              })
            ];
          };
        };
}
