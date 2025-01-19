{ pkgs, config, inputs, lib, ... }:
{
  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      ionos-password = {
        path = "/run/user/1000/secrets/ionos";
      };
    };
  };

  modules = {
    zsh.enable = true;
    theme.enable = true;
    librewolf.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    
    mail = {
      enable = true;
      password = config.sops.secrets.ionos-password.path;
    };

    irssi = {
      enable = true;
      user = "fxttr";
    };

    sway = {
      enable = true;
      wallpaper = "${inputs.media}/wallpaper/38c3.jpg";
    };

    waybar = {
      enable = true;
      mobile = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    ssh = {
      enable = true;
      hashKnownHosts = true;

      matchBlocks = {
        "github" = {
          hostname = "github.com";
          user = "git";
          identityFile = config.sops.secrets.ssh.path;
        };

        "codeberg" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = config.sops.secrets.ssh.path;
        };

        "workstation" = {
          hostname = "192.168.0.200";
          user = "marrero";
          identityFile = config.sops.secrets.ssh.path;
        };

        "lab0" = {
          hostname = "192.168.0.201";
          user = "marrero";
          identityFile = config.sops.secrets.ssh.path;
        };

        "rpi" = {
          hostname = "192.168.0.202";
          user = "marrero";
          identityFile = config.sops.secrets.ssh.path;
        };
      };
    };

    git = {
      enable = true;
      userName = "Florian Marrero Liestmann";
      userEmail = "f.m.liestmann@fx-ttr.de";
      ignores = [
        ".direnv/"
        ".cache/"
      ];
      extraConfig = {
        core = {
          editor = "vim";
          whitespace = "-trailing-space";
        };
        log = {
          abbrevCommit = true;
        };
        pull = {
          rebase = false;
        };
      };
      signing = {
        signByDefault = true;
        key = "D1912EEBC3FBEBB4";
      };
    };
  };

  home.packages = (with pkgs; [
    signal-desktop
    element-desktop
    discord
    dbeaver-bin
    spotify
  ]);
}
