{ config, pkgs, lib, inputs, ... }: {
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      { directory = "/var/log"; }
      { directory = "/etc/NetworkManager/system-connections"; }
      { directory = "/var/lib/systemd/coredump"; }
      { directory = "/var/lib/nixos"; }
      { directory = "/var/lib/libvirt"; }
      { directory = "/home/marrero"; }
      { directory = "/nix"; }
    ];
    files = [ "/etc/machine-id" ];
  };
}
