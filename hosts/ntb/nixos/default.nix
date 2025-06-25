{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./services.nix
    ./networking.nix
    ./security.nix
    ./users.nix
    ./impermanence.nix
  ];

  sops = {
    age = {
      keyFile = "/persist/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    settings = {
      trusted-public-keys =
        [ "fxttr.cachix.org-1:TBvPEn0MZT1PB89c1S8KWyWEmxbWMPW58lqODJuaH94=" ];

      substituters = [ "https://fxttr.cachix.org" ];
    };
  };

  programs = { zsh.enable = true; };

  modules = { river.enable = true; };

  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [ vim git home-manager htop ];
  };

  fonts.packages = with pkgs; [ source-code-pro font-awesome ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
  };
}
