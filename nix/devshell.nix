{ pkgs }:
let
  hbuild = pkgs.writeShellScriptBin "hbuild" ''
    home-manager switch --flake . "$@"
  '';

  nbuild = pkgs.writeShellScriptBin "nbuild" ''
    if [ -z "''${REMOTE+x}" ]; then
      sudo nixos-rebuild switch --flake . "$@"
    else
      nixos-rebuild switch --flake . \
        --sudo \
        --build-host "$REMOTE" \
        --target-host "$REMOTE" "$@"
    fi
  '';
in
pkgs.mkShell {
  nativeBuildInputs = [
    hbuild
    nbuild
    pkgs.sops
    pkgs.nixfmt
    pkgs.nixfmt-tree
    pkgs.deadnix
    pkgs.statix
  ];
}
