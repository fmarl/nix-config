{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./services.nix
      ./networking.nix
      ./security.nix
    ];

  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  nix = {
    nixPath =
      [
        "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
        "nixos-config=/persist/etc/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];

    settings = {
      trusted-public-keys = [
        "fxttr.cachix.org-1:TBvPEn0MZT1PB89c1S8KWyWEmxbWMPW58lqODJuaH94="
      ];

      substituters = [
        "https://fxttr.cachix.org"
      ];
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    zsh.enable = true;
    dconf.enable = true;
  };

  modules.sway.enable = true;

  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs;
      [
        vim
        git
        htop
        home-manager
        pinentry-curses
      ];
  };

  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
  ];

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPasswordFile = config.sops.secrets.root-password.path;
      };

      marrero = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Marrero Liestmann";
        hashedPasswordFile = config.sops.secrets.user-password.path;
        extraGroups = [ "wheel" ];
        group = "users";
        uid = 1000;
        home = "/home/marrero";
        shell = pkgs.zsh;
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
