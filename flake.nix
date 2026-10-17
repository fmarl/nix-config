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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:nixpak/nixpak";
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

      configurations = import ./nix/configurations.nix {
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
      inherit (configurations) nixosConfigurations homeConfigurations;

      devShells.${system}.default = import ./nix/devshell.nix { inherit pkgs; };

      packages.${system} = {
        installer = import ./nix/installer.nix {
          inherit nixpkgs self system;
          inherit (configurations) hosts;
        };

        new-host = import ./nix/new-host.nix { inherit pkgs; };
      };

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
