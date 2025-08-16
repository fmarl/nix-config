{ pkgs, config, ... }:
{
  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets.ssh.path = "/run/user/1000/secrets/ssh";
  };

  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    tmux.enable = true;
    river.enable = true;
    waybar.enable = true;

    irssi = {
      enable = true;
      user = "fxttr";
    };
  };

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
          editor = "hx";
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
        signByDefault = false;
        key = "D1912EEBC3FBEBB4";
      };
    };
  };

  home.packages = with pkgs; [
    signal-desktop-bin
    obsidian
  ];
}
