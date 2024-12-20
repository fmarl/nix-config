{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-code.url = "github:fxttr/nix-code";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils.inputs.systems.follows = "systems";

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
        legacyPackages = 
          import inputs.nixpkgs {
            config = {
              allowUnfree = true;
            };
          };

        extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux".vscode-marketplace;

        commonModules = name: [
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

              experimental-features = [ "nix-command" "flakes" ];

              optimise.automatic = true;
            };

            networking.hostName = name;
          }
          ./hosts/${name}
        ];

        mkSystem = name: cfg: nixpkgs.lib.nixosSystem {
          system = cfg.system or "x86_64-linux";
          modules = (commonModules name) ++ (cfg.modules or []);
          specialArgs = inputs;
        };

        systems = {
          workstation = {
            modules = [
                inputs.home-manager.nixosModules.home-manager
                inputs.sops-nix.nixosModules.sops
                inputs.coco.nixosModules.nixos
            ];
          };

          ntb = {
            modules = [
                inputs.home-manager.nixosModules.home-manager
                inputs.sops-nix.nixosModules.sops
                inputs.coco.nixosModules.nixos
            ];
          };
        };
      in
      {
        nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems;

        devShells.default = legacyPackages.mkShell {
          nativeBuildInputs = with legacyPackages; [
            nixpkgs-fmt
            (inputs.nix-code.packages."x86_64-linux".default {
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
