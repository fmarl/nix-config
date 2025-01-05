{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.xmonad;
in
{
  options.modules.xmonad.enable = mkEnableOption "Install and configure xmonad";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm.enable = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };
  };
 }
