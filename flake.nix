{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, flake-utils, nix-vscode-extensions, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        extensions = nix-vscode-extensions.extensions.${system}.vscode-marketplace;
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nixpkgs-fmt
            (vscode-with-extensions.override {
              vscodeExtensions = [
                extensions.bbenoist.nix
                extensions.mkhl.direnv
              ];
            })
          ];
        };
      });
}
