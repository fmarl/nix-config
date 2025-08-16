{ config, pkgs, ... }:
{
  users = {
    mutableUsers = false;

    users.marrero = {
      isNormalUser = true;
      createHome = true;
      description = "Florian Marrero Liestmann";
      hashedPasswordFile = config.sops.secrets.user-password.path;
      extraGroups = [
        "wheel"
        "wireshark"
        "podman"
        "tss"
      ];
      group = "users";
      uid = 1000;
      home = "/home/marrero";
      shell = pkgs.zsh;
    };
  };
}
