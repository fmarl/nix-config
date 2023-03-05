{ pkgs, config, nixosConfigurations, inputs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  home.stateVersion = "22.11";

  coco = {
    sway.enable = true;
    sway.wallpaper = "${inputs.artwork}/wallpapers/nix-wallpaper-nineish-dark-gray.png";
    waybar.enable = true;
    zsh.enable = true;
    emacs.enable = true;
    irssi.enable = true;
  #  irssi.name = "fxttr";
  };

  home.packages = (with pkgs; [
    firefox
    spotify
    ranger
    feh
    obsidian
    nixpkgs-fmt
    tdesktop
    discord
    speedcrunch
    jetbrains.idea-ultimate
    jetbrains.datagrip
  ]);

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
        identityFile = nixosConfigurations.ntb.config.sops.secrets.github.path;
      };
      "codeberg" = {
        hostname = "codeberg.org";
        user = "git";
        identityFile = nixosConfigurations.ntb.config.sops.secrets.codeberg.path;
      };
      "mls" = {
        hostname = "192.168.0.3";
        user = "florian";
        identityFile = nixosConfigurations.ntb.config.sops.secrets.mls.path;
      };
    };
  };
  
  programs.git = {
    enable = true;
    userName = "Florian Büstgens";
    userEmail = "fb@fx-ttr.de";
#    signing = { 
#      signByDefault = true;
#      key = "865E0BA2011DAEE1A83F895E2EEC4010A0299470";
#    };
  };

  home.file = {
    ".emacs.d" = {
      source = inputs.emacs-cfg;
      recursive = true;
    };
  };
}
