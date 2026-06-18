{
  description = "fx's nix-config";

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

    irssi-themes = {
      url = "github:fxttr/irssi-themes";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      flib = import ./lib {
        inherit inputs self pkgs system;
        lib = nixpkgs.lib;
      };
    in
    {
      inherit (flib) nixosConfigurations homeConfigurations;

      devShells.${system}.default = import ./nix/devshell.nix { inherit pkgs; };
    };
}
