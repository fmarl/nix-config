{ config, pkgs, lib, ... }:

{
  security.rtkit.enable = true;
  security.polkit.enable = true;

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

    blueman.enable = true;

    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database DBuser origin-address auth-method
        local all       all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh = {
      enable = false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
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
}
