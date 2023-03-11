{ pkgs, config, inputs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = "${inputs.secrets}/secrets/ssh.yaml";

    age = {
      keyFile = "/home/florian/.config/sops/age/keys.txt";
      generateKey = true;
    };
    
    secrets = {
      github = {
        path = "/run/user/1000/secrets/github";
      };
      codeberg = {
        path = "/run/user/1000/secrets/codeberg";
      };
      mls = {
        path = "/run/user/1000/secrets/mls";
      };
      rpi = {
        path = "/run/user/1000/secrets/rpi";
      };
      cachix = {
        path = "/run/user/1000/secrets/cachix";
      };
      unimail = {
        path = "/run/user/1000/secrets/unimail";
      };
    };
  };

  coco = {
    sway.enable = true;
    sway.wallpaper = "${inputs.artwork}/wallpapers/nix-wallpaper-nineish-dark-gray.png";
    waybar.enable = true;
    zsh.enable = true;
    emacs.enable = true;
    irssi.enable = true;
    #irssi.name = "fxttr";
    mail.enable = true;
  };

  programs = {
    vscode.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ssh = {
      enable = true;
      hashKnownHosts = true;

      matchBlocks = {
        "github" = {
          hostname = "github.com";
          user = "git";
          identityFile = config.sops.secrets.github.path;
        };
        "codeberg" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = config.sops.secrets.codeberg.path;
        };
        "mls" = {
          hostname = "192.168.0.3";
          user = "florian";
          identityFile = config.sops.secrets.mls.path;
        };
        "rpi" = {
          hostname = "192.168.0.4";
          user = "florian";
          identityFile = config.sops.secrets.rpi.path;
        };
      };
    };

    git = {
      enable = true;
      userName = "Florian Büstgens";
      userEmail = "fb@fx-ttr.de";
      signing = {
        signByDefault = true;
        key = "865E0BA2011DAEE1A83F895E2EEC4010A0299470";
      };
    };
  };

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
    stateVersion = "22.11";

    file = {
      ".emacs.d" = {
        source = inputs.emacs-cfg;
        recursive = true;
      };
    };

    packages = (with pkgs; [
      firefox
      spotify
      ranger
      feh
      obsidian
      nixpkgs-fmt
      cachix
      tdesktop
      discord
      jetbrains.idea-ultimate
      jetbrains.datagrip
      speedcrunch
      smartgithg
    ]);
  };

  accounts.email = {
    accounts.uni = {
      address = "florian.buestgens@studium.fernuni-hagen.de";
      imap.host = "studium.fernuni-hagen.de";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      mu.enable = true;
      primary = true;
      realName = "Florian Büstgens";
      signature = {
        text = ''
             Mit freundlichen Grüßen
             Florian Büstgens
        '';
        showSignature = "append";
      };
      passwordCommand = "cat " + config.sops.secrets.unimail.path;
      smtp = {
        host = "studium.fernuni-hagen.de";
      };
      userName = "florian.buestgens@studium.fernuni-hagen.de";
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
