{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.swm;
in
{
  options.modules.swm.enable = mkEnableOption "Install swm";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
      };

      displayManager.session = [
        {
          manage = "desktop";
          name = "swm";
          start = ''
            ${pkgs.swm}/bin/swm
          '';
        }
      ];

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

  };
}
