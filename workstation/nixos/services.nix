{ config, pkgs, lib, ... }:
{

  services = {
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
