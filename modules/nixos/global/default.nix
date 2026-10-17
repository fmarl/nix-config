{
  lib,
  pkgs,
  flib,
  theme,
  ...
}:
{
  imports = flib.importDir ./.;

  time.timeZone = "Europe/Berlin";

  console = {
    keyMap = "us-acentos";
    colors = theme.console;
  };

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

  environment = {
    defaultPackages = lib.mkForce [ ];
    systemPackages = [ pkgs.home-manager ];
  };

  systemd.coredump.enable = true;

  system.stateVersion = "24.05";
}
