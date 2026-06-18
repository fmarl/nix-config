{
  config,
  lib,
  pkgs,
  ...
}:


let
  cfg = config.modules.river;

in
{
  options.modules.river.enable = lib.mkEnableOption "Install and configure river";

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "${pkgs.river-classic}/bin/river";
          user = "marrero";
        };
      };
    };
  };
}
