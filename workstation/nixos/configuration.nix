{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./security.nix
      ./services.nix
      ./networking.nix
      ./boot.nix
      ./sway.nix
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
      trusted-users = [ "root" "marrero" ];
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
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    zsh.enable = true;
    dconf.enable = true;
  };

  coco.xmonad.enable = true;
  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs;
      [
        vim
        htop
        git
        home-manager
        pinentry-curses
      ];
  };

  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
  ];

  console = {
    keyMap = "de";
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "REDACTED";
      };

      marrero = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Marrero Liestmann";
        initialHashedPassword = "REDACTED";
        extraGroups = [ "wheel" "docker" "lxd" "scanner" "lp" ];
        group = "users";
        uid = 1000;
        home = "/home/marrero";
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = [
	        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA7qmgZlNHPIvKN0QMyFAgEB58WBsAMRc829UBA12N/M marrero@notebook"
        ];
      };
    };
  };

  time.timeZone = "Europe/Berlin";

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      insecure-registries = [ "svc:5000" ];
    };
  };

  system.stateVersion = "24.05";

  security.sudo.execWheelOnly = true;
}
