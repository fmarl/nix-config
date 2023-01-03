{ config, pkgs, lib, ... }:

{
  security.rtkit.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    dbus = {
      enable = true;
    };

    pcscd.enable = true;

    xserver = {
      enable = true;

      libinput = {
        enable = true;
        touchpad.tapping = true;
        touchpad.naturalScrolling = true;
        touchpad.scrollMethod = "twofinger";
        touchpad.clickMethod = "clickfinger";
      };

      displayManager = {
        lightdm.enable = true;
      };
      
      layout = "de";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
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
}
