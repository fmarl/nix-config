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

  sops = {
    age = {
      keyFile = "/sops/age/keys.txt";
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
    zsh.enable = true;
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
        home-manager
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

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5wD+zMGIVaENIRRxTwK0w+mqWfpeABf4JIp0zA7Vs3 marrero@ntb"
        ];
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
