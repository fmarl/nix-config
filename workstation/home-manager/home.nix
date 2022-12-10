{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  home.stateVersion = "22.11";

  home.packages = [
    pkgs.firefox
    pkgs.thunderbird
    pkgs.jetbrains.idea-community
    pkgs.spotify
    pkgs.rxvt-unicode
    pkgs.feh
    pkgs.dunst
    pkgs.mupdf
    pkgs.ranger
    pkgs.xmobar
    pkgs.dmenu
    pkgs.obsidian
    pkgs.htop
    pkgs.nixpkgs-fmt
  ];

  programs.vscode.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Florian Büstgens";
    userEmail = "fb@fx-ttr.de";
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    initExtra = ''
      autoload -U promptinit && 
      promptinit && 
      prompt suse && 
      setopt prompt_sp
    '';

    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch";
    };
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = pkgs.writeText "config.hs" (builtins.readFile ./programs/xmonad/config.hs);
  };
}
