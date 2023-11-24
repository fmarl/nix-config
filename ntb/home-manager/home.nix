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
      ionosmail = {
        path = "/run/user/1000/secrets/ionosmail";
      };
    };
  };

  coco = {
    sway = {
      enable = true;
      wallpaper = "${inputs.artwork}/wallpapers/nix-wallpaper-nineish-dark-gray.png";
    };

    waybar = {
      enable = true;
      mobile = true;
    };

    zsh.enable = true;
    emacs.enable = true;

    irssi = {
      enable = true;
      user = "fxttr";
    };

    theme.enable = true;
  };

  services.blueman-applet.enable = true;

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };

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
      userName = "Florian Marrero Liestmann";
      userEmail = "f.m.liestmann@fx-ttr.de";
      signing = {
        signByDefault = true;
        key = "9BF161F4A5720E3674FCEC8F6DEDAC0CEF0639C1";
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
      zathura
      nixpkgs-fmt
      speedcrunch
      rnix-lsp
      signal-desktop
      discord
      obsidian
    ]);
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
