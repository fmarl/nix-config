{ pkgs, config, nixosConfigurations, inputs, lib, ... }: {
  imports = [
	  ./../../lib/hm/programs/emacs.nix
    ./../../lib/hm/programs/sway.nix
    ./../../lib/hm/programs/irssi.nix
    ./../../lib/hm/programs/zsh.nix
    ./../../lib/hm/services/waybar.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  home.stateVersion = "22.11";

  home.packages = (with pkgs; [
    firefox
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
