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
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };

    zsh.enable = true;
    dconf.enable = true;
  };

  coco = {
    sway.enable = true;
    ntp.enable = true;
  };

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

  console = {
    keyMap = "de";
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
        description = "Florian Büstgens";
        initialHashedPassword = "REDACTED";
        extraGroups = [ "wheel" ];
        group = "users";
        uid = 1000;
        home = "/home/florian";
        shell = pkgs.zsh;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  security.sudo.execWheelOnly = true;
}
