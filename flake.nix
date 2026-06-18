{
  description = "fx's nix-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      fenix,
      ...
    }:
    let
      vars = import ./vars.nix;

      pkgs = import nixpkgs {
        inherit (vars) system;
        config.allowUnfree = true;
        overlays = [ fenix.overlays.default ];
      };

      homeModules = [
        ./modules/home-manager
        ./host/home-manager
      ];
    in
    {
      homeConfigurations.${vars.user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit vars; };
        modules = homeModules;
      };

      devShells.${vars.system}.default = pkgs.mkShell {
        name = "nix-config";
        packages = with pkgs; [
          nil
          nixfmt-rfc-style
        ];
      };

      darwinConfigurations.${vars.hostname} = nix-darwin.lib.darwinSystem {
        inherit pkgs;
        inherit (vars) system;
        specialArgs = { inherit vars; };
        modules = [
          ./host/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit vars; };
              users.${vars.user} = { imports = homeModules; };
            };
          }
        ];
      };
    };
}
