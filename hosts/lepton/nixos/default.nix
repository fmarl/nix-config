{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./services.nix
    ./networking.nix
    ./security.nix
    ./users.nix
  ];

  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  programs = {
    zsh.enable = true;
  };

  modules = {
    niri.enable = true;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [
      vim
      git
      home-manager
      htop
    ];
  };

  fonts.packages = with pkgs; [
    aporetic
    font-awesome
  ];

  services.blueman.enable = true;
}
