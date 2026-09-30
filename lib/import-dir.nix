{ lib }:
dir:
let
  isImportable =
    name: type:
    (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix") || type == "directory";
in
map (n: dir + "/${n}") (lib.attrNames (lib.filterAttrs isImportable (builtins.readDir dir)))
