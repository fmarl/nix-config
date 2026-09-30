{
  config,
  lib,
  pkgs,
  primaryUser,
  ...
}:
let
  cfg = config.modules.river;
in
{
  options.modules.river.enable = lib.mkEnableOption "Install and configure river";

  config = lib.mkIf cfg.enable {
    modules.wayland.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.river-classic}/bin/river";
          user = primaryUser;
        };
      };
    };
  };
}
