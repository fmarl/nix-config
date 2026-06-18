{ pkgs }:
let
  hbuild = pkgs.writeShellScriptBin "hbuild" ''
    #!/usr/bin/env bash
    home-manager switch --flake . "$@"
  '';

  nbuild = pkgs.writeShellScriptBin "nbuild" ''
    #!/usr/bin/env bash
    if [ -z "''${REMOTE+x}" ]; then
      sudo nixos-rebuild switch --flake . "$@"
    else
      nixos-rebuild switch --flake . \
        --use-remote-sudo \
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
  ];
}
