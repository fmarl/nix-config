{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./kernel.nix
      ./services.nix
    ];

  nix.nixPath =
    [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/persist/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "fxttr.cachix.org-1:TBvPEn0MZT1PB89c1S8KWyWEmxbWMPW58lqODJuaH94="
  ];

  nix.settings.substituters = [
    "https://hydra.iohk.io"
    "https://devenv.cachix.org"
    "https://fxttr.cachix.org"
  ];

  nix.extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
    "experimental-features = nix-command flakes";

  networking.hostName = "workstation";
  networking.hostId = "04686870";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs;
    [
      vim
      htop
      git
      home-manager
      pinentry-curses
    ];

  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome
  ];

  console = {
    keyMap = "en";
  };

  coco = {
    sway.enable = true;
    ntp.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "\$6\$a7aqpD33dBUhDyDy\$vExV0PWsMnOsvlVMPyFTNFRgiPLjZ8H4E7QmK.xaL/Z4mYullm9f8cq6uHiFztvOeQggvea80w1q./Hj/3QnJ.";
      };

      florian = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Büstgens";
        initialHashedPassword = "\$6\$IynztI2Y8F2DIMUD\$REn16J9uoLpQqDDepvdP./HFGF4TK4od2NHBMhbkhL.0BYWdn6ztWY3Lmgsmrf8InEo5FO0h0mxlwzfmBdiA8/";
        extraGroups = [ "wheel" "docker" "lxd" ];
        group = "users";
        uid = 1000;
        home = "/home/florian";
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBOAvFL34WZRnKtwMx27zAXq4Z8vQxK8oR+O+6UYwet eddsa-key-20221216"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCbnpc2pnr/wk64fHe+nI3ydgk6umjHflT8vkN6IPHL fb@fx-ttr.de"
        ];
      };
    };
  };

  nix.settings.trusted-users = [ "root" "florian" ];

  virtualisation.lxd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
