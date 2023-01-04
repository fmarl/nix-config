{ pkgs, inputs, ... }: {
  imports = [
	  ./../../lib/hm/programs/emacs.nix
    ./../../lib/hm/programs/sway.nix
    ./../../lib/hm/services/waybar.nix
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
    python3
    python310Packages.epc
  ]);

  programs.mu.enable = true;
  programs.msmtp.enable = true;
  programs.mbsync.enable = true;

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

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    enableCompletion = true;

    initExtra = ''
      autoload -U promptinit && 
      promptinit && 
      prompt suse && 
      setopt prompt_sp
    '';

    sessionVariables = {
      GPG_TTY = "$(tty)";
    };

    shellAliases = {
      ll = "ls -l";
    };
  };

  home.file = {
    ".emacs.d" = {
      source = inputs.emacs-cfg;
      recursive = true;
    };
  };
}
