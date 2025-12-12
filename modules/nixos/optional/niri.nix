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
    services.greetd = {
      enable = true;
      
      settings = rec {
        initial_session = {
          command = "${pkgs.niri}/bin/niri";
          user = "marrero";
        };

        default_session = initial_session;
      };
    };

    programs.niri.enable = true;
  };
}
