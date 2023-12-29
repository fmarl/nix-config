{ config, pkgs, lib, ... }:
{
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    dbus.enable = true;
    pcscd.enable = true;
    blueman.enable = true;
    openssh.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  
  systemd = {
    coredump.enable = false;
  };
}
