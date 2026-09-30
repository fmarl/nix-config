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
        inherit
          inputs
          self
          pkgs
          system
          ;
        inherit (nixpkgs) lib;
      };
    in
    {
      inherit (flib) nixosConfigurations homeConfigurations;

      devShells.${system}.default = import ./nix/devshell.nix { inherit pkgs; };

      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system} =
        nixpkgs.lib.mapAttrs' (
          name: cfg: nixpkgs.lib.nameValuePair "nixos-${name}" cfg.config.system.build.toplevel
        ) self.nixosConfigurations
        // nixpkgs.lib.mapAttrs' (
          name: cfg: nixpkgs.lib.nameValuePair "home-${name}" cfg.activationPackage
        ) self.homeConfigurations;
    };
}
