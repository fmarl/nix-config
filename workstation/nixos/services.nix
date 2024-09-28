{ config, pkgs, lib, ... }:
{

  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    minio = {
      enable = true;
      browser = true;
      accessKey = "access123";
      secretKey = "secret123";
      region = "eu-central-1";
      dataDir = [ "/mnt/minio" ];
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
