{ config, pkgs, lib, ... }:
{
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services = {
    dbus.enable = true;

    pcscd.enable = true;
    
    udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
