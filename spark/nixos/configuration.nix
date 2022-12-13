{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./time.nix
      ./services.nix
    ];

  nix.nixPath =
    [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/persist/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

  nix.extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
    "experimental-features = nix-command flakes";

  networking.hostName = "spark";
  networking.hostId = "04686870";
  networking.useDHCP = false;
  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.interfaces.enp3s0.ipv4.addresses = [{
    address = "192.168.0.4";
    prefixLength = 24;
  }];

  environment.systemPackages = with pkgs;
    [
      vim
      htop
      home-manager
    ];

  fonts.fonts = with pkgs; [
    source-code-pro
  ];

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "\$6\$vZqI/GpbqOqJwLYs\$qllsGcXZdzrQti4Gi67orVG.MkMT8.w79k/zhY3x9rGJHgUVZ3T7M5SnABKKklEEq9nTz80SU4qAyf8owps7H/";
      };
      spark = {
        createHome = true;
        isNormalUser = true;
        initialHashedPassword = "\$6\$XSR5eFZ3EoVwq7e3\$uoC49igTG8FBo6Cdq6vuEgylJgeTDe8TRfhJ1vFdG5hu/uWsCXSiCPc/Qea7y7MQQA9grVdbqoAXd2ciw0.Ve1";
        extraGroups = [ "wheel" "docker" ];
        group = "users";
        uid = 1000;
        home = "/home/spark";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtFZ7KIi2LNNqxXFdABdUNMM4wxqul2/UfydA/cNEj+ fb@fx-ttr.de" ];
      };
    };
  };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
