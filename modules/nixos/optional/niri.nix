{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.niri;

in
{
  options.modules.niri.enable = mkEnableOption "Install and configure niri";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    
    services.greetd = {
      enable = true;
      
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.niri}/bin/niri-session";
          user = "greeter";
        };
      };
    };

    programs.niri.enable = true;
  };
}
