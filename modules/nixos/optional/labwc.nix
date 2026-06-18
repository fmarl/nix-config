{
  config,
  lib,
  pkgs,
  ...
}:


let
  cfg = config.modules.labwc;

in
{
  options.modules.labwc.enable = lib.mkEnableOption "Install and configure labwc";

  config = lib.mkIf cfg.enable {
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
