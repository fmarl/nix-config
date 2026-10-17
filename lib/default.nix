{ lib }:
{
  importDir = import ./import-dir.nix { inherit lib; };
  themes = import ./themes.nix { inherit lib; };
}
