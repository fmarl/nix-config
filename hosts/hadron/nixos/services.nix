{ primaryUser, ... }:
{
  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };

    openssh = {
      enable = true;
      openFirewall = false;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowUsers = [ primaryUser ];
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        X11Forwarding = false;
      };

      hostKeys = [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
