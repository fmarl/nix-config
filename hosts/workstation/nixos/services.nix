{ config, pkgs, lib, ... }: {
  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    dbus.enable = true;

    pcscd.enable = true;

    pulseaudio.enable = false;

    udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        X11Forwarding = false;
      };

      hostKeys = [
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
}
