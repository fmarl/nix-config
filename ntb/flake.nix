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
    artwork = {
      url = "github:NixOS/nixos-artwork";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad = {
      url = "github:fxttr/xmonad-cfg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-cfg, artwork, sops-nix, secrets, coco, xmonad, ... }@inputs: rec {
    legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );

    nixosConfigurations = {
      ntb = nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages.x86_64-linux;
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          sops-nix.nixosModules.sops
          coco.nixosModules.nixos
        ];
      };
    };

    homeConfigurations = {
      "florian@ntb" = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home-manager/home.nix
          coco.nixosModules.home-manager
          sops-nix.homeManagerModules.sops
        ];
      };
    };
  };
}
