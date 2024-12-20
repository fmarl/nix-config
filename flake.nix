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

  outputs = { self, nixpkgs, flake-utils, nix-vscode-extensions, nix-code, home-manager, coco, sops-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        extensions = nix-vscode-extensions.extensions.${system}.vscode-marketplace;

        hostname = pkgs.config.networking.hostName;
        user = builtins.GetEnv "USER";
      in
      {
        nixosConfigurations = {
          ${hostname} = import ./${hostname}/flake.nix {
            inherit self nixpkgs home-manager coco sops-nix;          
          };
        };

        homeConfigurations = {
           "${user}@${hostname}" = import ./${hostname}/flake.nix {
            inherit self nixpkgs home-manager coco sops-nix;          
          };
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nixpkgs-fmt
            (nix-code.packages.${system}.default {
              extensions = [
                extensions.bbenoist.nix
                extensions.mkhl.direnv
              ];

              userDir = "$HOME/.vscode/${self}";
            })
          ];
        };
      });
}
