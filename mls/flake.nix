{
  description = "The configuration for my Spark and machine learning development servers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    vscode-server.url = "github:msteen/nixos-vscode-server";
    rocm.url = "github:nixos-rocm/nixos-rocm";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, secrets, coco, vscode-server, rocm, ... }@inputs: rec {
    legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );

    nixosConfigurations = {
      mls = nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages.x86_64-linux;
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          coco.nixosModules.nixos
          sops-nix.nixosModules.sops
          vscode-server.nixosModule
        ];
      };
    };

    homeConfigurations = {
      "florian@mls" = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          inherit nixosConfigurations;
        };
        modules = [
          ./home-manager/home.nix
          coco.nixosModules.home-manager
        ];
      };
    };
  };
}
