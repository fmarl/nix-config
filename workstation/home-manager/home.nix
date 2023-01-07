{ pkgs, config, nixosConfigurations, inputs, lib, ... }: 
{
  imports = [
    ./../../lib/hm/programs/emacs.nix
    ./../../lib/hm/programs/sway.nix
    ./../../lib/hm/programs/zsh.nix
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
  ]);

  programs.mu.enable = true;
  programs.msmtp.enable = true;
  programs.mbsync.enable = true;

  programs.irssi = {
    enable = true;
    networks =
      {
        libera = {
          type = "IRC";
          nick = "fxttr";
          name = "fxttr";
          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = false;
          };
          channels = {
            nixos.autoJoin = true;
          };
        };
      };
  };

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
        hostname = "192.168.0.3";
        user = "florian";
        identityFile = nixosConfigurations.workstation.config.sops.secrets.mls.path;
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

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    enableCompletion = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

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
