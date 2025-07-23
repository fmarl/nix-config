{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.niri;

in {
  options.modules.niri.enable = mkEnableOption "Install and configure niri";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      displayManager.lightdm.enable = true;

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    programs.niri.enable = true;
  };
}
