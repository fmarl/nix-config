{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./security.nix
    ./services.nix
    ./networking.nix
    ./boot.nix
  ];

  #sops = {
  #  age = {
  #    keyFile = "/sops/age/keys.txt";
  #    generateKey = true;
  #  };
  #};

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  programs.zsh.enable = true;

  modules.river.enable = true;

  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [
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
      marrero = {
        isNormalUser = true;
        createHome = true;
        description = "Florian Marrero Liestmann";
        #hashedPasswordFile = config.sops.secrets.user-password.path;
      initialHashedPassword = "\$6\$evo8YlCWC4DLIsho\$M2q2sMIGI5FV3fVWMpdZ03qZ1mDM2u8ZyVlYRoDtZiW2T93kvrAM8YOgpSI0qAbWQedF.veZQwVbZmFdW3YKJ1";
	extraGroups = [
          "wheel"
          "tss"
          "podman"
          "kvm"
        ];
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
      };
    };
  };
}
