{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./services.nix
    ./networking.nix
    ./users.nix
  ];

  modules.niri.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
  ];

  services.blueman.enable = true;
}
