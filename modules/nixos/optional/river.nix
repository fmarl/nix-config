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

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.river-classic}/bin/river";
          user = "marrero";
        };
        
        default_session = initial_session;
      };
    };
  };
}
