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
