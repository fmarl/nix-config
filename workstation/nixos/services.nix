{ config, pkgs, lib, ... }:
{

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

    openssh = {
      enable = true;
      passwordAuthentication = true;
      hostKeys =
        [
          {
            path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
          {
            path = "/persist/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
            bits = 4096;
          }
        ];
    };
  };

  systemd = {
    coredump.enable = false;
  };
}
