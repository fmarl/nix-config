{ config, pkgs, ... }:
{
  users = {
    mutableUsers = true;

    users.marrero = {
      isNormalUser = true;
      createHome = true;
      description = "Florian Marrero Liestmann";
      extraGroups = [
        "wheel"
        "wireshark"
        "libvirtd"
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
