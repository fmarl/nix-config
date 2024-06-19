{ config, pkgs, lib, ... }:
{
  xdg.portal = {
    enable = true;
    config.common.default = "*";
     extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    dbus = {
      enable = true;
    };

    blueman.enable = true;

    pcscd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      videoDrivers = [ "nvidia" ];

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };
  };

  systemd = {
    coredump.enable = false;
  };
}
