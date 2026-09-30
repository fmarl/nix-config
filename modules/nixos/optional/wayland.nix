{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.wayland;
in
{
  options.modules.wayland = {
    enable = lib.mkEnableOption "shared setup for wlroots-based compositors";

    lightdm = lib.mkEnableOption "LightDM as display manager";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        xdg.portal = {
          enable = true;
          wlr.enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
      }

      (lib.mkIf cfg.lightdm {
        services.xserver = {
          enable = true;

          displayManager.lightdm.enable = true;

          xkb = {
            layout = "us";
            variant = "altgr-intl";
          };
        };
      })
    ]
  );
}
