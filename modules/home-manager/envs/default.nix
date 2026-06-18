{ lib, ... }:
let
  here = ./.;
  isModule =
    name: type:
    type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
  modules = lib.attrNames (lib.filterAttrs isModule (builtins.readDir here));
in
{
  imports = map (n: here + "/${n}") modules;
}
