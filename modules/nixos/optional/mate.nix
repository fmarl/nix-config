{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.mate;

in
{
  options.modules.mate.enable = mkEnableOption "Install and configure mate";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      displayManager.lightdm.enable = true;

      desktopManager.mate = {
        enable = true;
        enableWaylandSession = true;
      };

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };
  };
}
