{ pkgs, config, nixosConfigurations, inputs, lib, coco, ... }: {

  nixpkgs.config.allowUnfree = true;

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  home.stateVersion = "22.11";

  coco = {
    sway.enable = false;
    waybar.enable = false;
    zsh.enable = true;
    emacs.enable = false;
    irssi.enable = false;
  };

  home.packages = (with pkgs; [
    ranger
    tmux
    nixpkgs-fmt
    rnix-lsp
  ]);

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
        identityFile = nixosConfigurations.mls.config.sops.secrets.github.path;
      };
      "codeberg" = {
        hostname = "codeberg.org";
        user = "git";
        identityFile = nixosConfigurations.mls.config.sops.secrets.codeberg.path;
      };
      "mls" = {
        hostname = "192.168.0.3";
        user = "florian";
        identityFile = nixosConfigurations.mls.config.sops.secrets.mls.path;
      };
      "rpi" = {
        hostname = "192.168.0.4";
        user = "florian";
        identityFile = nixosConfigurations.mls.config.sops.secrets.rpi.path;
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
}
