{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./security.nix
      ./services.nix
      ./networking.nix
      ./boot.nix
    ];

  nix = {
    nixPath =
      [
        "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
        "nixos-config=/persist/etc/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];

    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings = {
      trusted-users = [ "root" "florian" ];
      allowed-users = [ "@wheel" ];

      trusted-public-keys = [
        "fxttr.cachix.org-1:TBvPEn0MZT1PB89c1S8KWyWEmxbWMPW58lqODJuaH94="
      ];

      substituters = [
        "https://fxttr.cachix.org"
      ];
    };

    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";

    optimise.automatic = true;
  };

  programs = {
    zsh.enable = true;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs;
      [
        vim
        htop
        home-manager
        kompose
        kubectl
        kubernetes
        kubernetes-helm
      ];
  };

  console = {
    keyMap = "en";
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "REDACTED";
      };

      florian = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Marrero Liestmann";
        initialHashedPassword = "REDACTED";
        extraGroups = [ "wheel" "docker" "lxd" "scanner" "lp" ];
        group = "users";
        uid = 1000;
        home = "/home/florian";
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmqsZupzLhPNZype+QWyb4vST1T9xzb2Xaxg8xtctAU"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHTlnPb5Oe5B/JZfoBvgnuZFR1cQlkVjVo+bRMr2miv"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBE69pgHCSt009vZbr0++Y3mwDYhqsRfiXCU3jozBmjj"
        ];
      };
    };
  };

  system.stateVersion = "23.11";
}
