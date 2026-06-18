{ lib, ... }:
let
  here = ./.;
  isImportable =
    name: type:
    (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix") || type == "directory";
  children = lib.attrNames (lib.filterAttrs isImportable (builtins.readDir here));
in
{
  imports = map (n: here + "/${n}") children;
}
