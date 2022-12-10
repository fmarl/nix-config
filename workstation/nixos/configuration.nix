{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./time.nix
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
  ];

  nix.settings.substituters = [
    "https://hydra.iohk.io"
  ];

  nix.extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
    "experimental-features = nix-command flakes";

  networking.hostName = "workstation";
  networking.hostId = "04686870";
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 ];
  };

  environment.systemPackages = with pkgs;
    [
      emacs
      git
      home-manager
    ];

  fonts.fonts = with pkgs; [
    source-code-pro
  ];

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
        extraGroups = [ "wheel" "docker" ];
        group = "users";
        uid = 1000;
        home = "/home/florian";
        shell = pkgs.zsh;
      };
    };
  };

  virtualisation.docker.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "buildserver@lambda-insights.de";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
