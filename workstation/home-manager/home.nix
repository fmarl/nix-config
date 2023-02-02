{ pkgs, config, nixosConfigurations, inputs, lib, ... }: 
{
  imports = [
    ./../../lib/hm/programs/emacs.nix
    ./../../lib/hm/programs/sway.nix
    ./../../lib/hm/programs/zsh.nix
    ./../../lib/hm/services/waybar.nix
    ./../../lib/hm/programs/irssi.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  home.stateVersion = "22.11";

  home.packages = (with pkgs; [
    firefox
    spotify
    feh
    mupdf
    ranger
    obsidian
    nixpkgs-fmt
    cachix
    tdesktop
    element-desktop-wayland
  ]);

  programs.mu.enable = true;
  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  programs.vscode.enable = true;
  
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    hashKnownHosts = true;

    matchBlocks = {
      "github" = {
        hostname = "github.com";
        user = "git";
        identityFile = nixosConfigurations.workstation.config.sops.secrets.github.path;
      };
      "codeberg" = {
        hostname = "codeberg.org";
        user = "git";
        identityFile = nixosConfigurations.workstation.config.sops.secrets.codeberg.path;
      };
      "mls" = {
        hostname = "192.168.0.8";
        user = "florian";
        identityFile = nixosConfigurations.workstation.config.sops.secrets.mls.path;
      };
      "rpi" = {
        hostname = "192.168.0.4";
        user = "florian";
        identityFile = nixosConfigurations.workstation.config.sops.secrets.rpi.path;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Florian Büstgens";
    userEmail = "fb@fx-ttr.de";
    signing = {
      signByDefault = true;
      key = "865E0BA2011DAEE1A83F895E2EEC4010A0299470";
    };
  };

  home.file = {
    ".emacs.d" = {
      source = inputs.emacs-cfg;
      recursive = true;
    };
  };
}
