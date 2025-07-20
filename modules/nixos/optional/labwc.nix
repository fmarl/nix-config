{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.labwc;

in
{
  options.modules.labwc.enable = mkEnableOption "Install and configure labwc";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
      };

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    programs = {
      labwc.enable = true;
    };
  };
}
