{
  description = "fx's nix-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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
      flake-utils,
      home-manager,
      nix-darwin,
      fenix,
      ...
    }@inputs:
    let
      system = "aarch64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          fenix.overlays.default
        ];
      };
    in
    {
      homeConfigurations."florian.marreroliestmann" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/home-manager
          ./host/home-manager
        ];
      };

      darwinConfigurations = {
        HGDEMLFR003777 = nix-darwin.lib.darwinSystem {
          inherit system pkgs;
          modules = [
            ./host/darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users."florian.marreroliestmann" = {
                imports = [
                  ./modules/home-manager
                  ./host/home-manager
                ];
              };
            }
          ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [];
      };
    };
}
