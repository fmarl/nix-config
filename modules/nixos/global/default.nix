{ lib, ... }:
let
  here = ./.;
  isModule =
    name: type:
    type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
  children = lib.attrNames (lib.filterAttrs isModule (builtins.readDir here));
in
{
  imports = map (n: here + "/${n}") children;

  time.timeZone = "Europe/Berlin";

  console.keyMap = "us-acentos";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  systemd.coredump.enable = true;

  system.stateVersion = "24.05";
}
