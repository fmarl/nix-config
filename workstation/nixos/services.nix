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

    pcscd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver.videoDrivers = [ "nvidia" ];

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
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
