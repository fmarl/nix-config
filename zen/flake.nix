{
  description = "The configuration for my work systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

    artwork = {
      url = "github:NixOS/nixos-artwork";
      flake = false;
    };

    symo = {
      url = "github:fxttr/symo";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: rec {
    legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );

    nixosConfigurations = {
      zen = nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages.x86_64-linux;
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          inputs.sops-nix.nixosModules.sops
          inputs.coco.nixosModules.nixos
        ];
      };
    };

    homeConfigurations = {
      "florian@zen" = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home-manager/home.nix
          inputs.sops-nix.homeManagerModules.sops
          inputs.coco.nixosModules.home-manager
          inputs.symo.nixosModules.x86_64-linux.home-manager
        ];
      };
    };
  };
}
