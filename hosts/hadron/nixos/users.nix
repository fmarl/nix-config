{ config, pkgs, ... }:
{
  users = {
    mutableUsers = false;

    users = {
      marrero = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Marrero Liestmann";
        hashedPasswordFile = config.sops.secrets.user-password.path;
	extraGroups = [
          "wheel"
          "tss"
          "podman"
          "kvm"
        ];
        group = "users";
        uid = 1000;
        home = "/home/marrero";
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5wD+zMGIVaENIRRxTwK0w+mqWfpeABf4JIp0zA7Vs3 marrero@ntb"
        ];
      };
    };
  };
}
