{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.river;

in
{
  options.modules.river.enable = mkEnableOption "Install and configure river";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.xserver = {
      enable = true;

      displayManager.lightdm.enable = true;

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    programs.river.enable = true;
  };
}
