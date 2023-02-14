{
  description = "Common nixos configuration module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs;
      inherit (inputs) nixpkgs;

    in {
      inherit lib;

      nixosModule = inputs.self.nixosModules.nixos;

      nixosModules = {
        nixos = import ./modules/nixos;
        home-manager = ./modules/home-manager;
      };

      # defaultTemplate = {
      #   description = "Creates a host built on the dotfiles framework";
      #   path = ./template;
      # };
    };
}