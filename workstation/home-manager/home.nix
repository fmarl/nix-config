{ pkgs, inputs, ... }: {
  imports = [
	  ./emacs.nix
    ./sway.nix
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
    #signing = { 
    #  signByDefault = true;
    #  key = "0x123456789ABCD";
    #};
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

  home.file = {
    ".emacs.d" = {
      source = ./programs/emacs;
      recursive = true;
    };
    ".emacs.d/lsp-bridge" = {
      source = inputs.lsp-bridge;
      recursive = true;
    };
  };
}
