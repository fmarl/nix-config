{ pkgs }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nh
    sops
    nixfmt
    nixfmt-tree
    deadnix
    statix
  ];
}
