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

    settings = {
      trusted-public-keys = [
        "fxttr.cachix.org-1:TBvPEn0MZT1PB89c1S8KWyWEmxbWMPW58lqODJuaH94="
      ];

      substituters = [
        "https://fxttr.cachix.org"
      ];
    };

    extraOptions = "experimental-features = nix-command flakes";

    optimise.automatic = true;
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

  coco.sway.enable = true;

  console = {
    keyMap = "us-acentos";
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "\$6\$a7aqpD33dBUhDyDy\$vExV0PWsMnOsvlVMPyFTNFRgiPLjZ8H4E7QmK.xaL/Z4mYullm9f8cq6uHiFztvOeQggvea80w1q./Hj/3QnJ.";
      };

      marrero = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Marrero Liestmann";
        initialHashedPassword = "\$6\$IynztI2Y8F2DIMUD\$REn16J9uoLpQqDDepvdP./HFGF4TK4od2NHBMhbkhL.0BYWdn6ztWY3Lmgsmrf8InEo5FO0h0mxlwzfmBdiA8/";
        extraGroups = [ "wheel" ];
        group = "users";
        uid = 1000;
        home = "/home/marrero";
        shell = pkgs.zsh;
      };
    };
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  
  system.stateVersion = "24.05";
}
