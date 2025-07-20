{
  pkgs,
  config,
  ...
}:
{
  sops = {
    age = {
      keyFile = "/persist/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = {
      ssh = {
        path = "/run/user/1000/secrets/ssh";
      };
    };
  };

  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    neovim.enable = true;
    river.enable = true;

    irssi = {
      enable = true;
      user = "fxttr";
    };

    waybar = {
      enable = true;
      mobile = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    vscode.enable = true;
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

        "bitbucket" = {
          hostname = "bitbucket.org";
          user = "git";
          identityFile = config.sops.secrets.ssh.path;
        };

        "workstation" = {
          hostname = "192.168.0.200";
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
          editor = "nvim";
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

  home.packages = (
    with pkgs;
    [
      signal-desktop-bin
      spotify
      obsidian
      (writeShellScriptBin "nrun" ''
        NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$1
      '')
      (writeShellScriptBin "metaflake" ''
        nix develop github:flmarrero/metaflakes#$1 --no-write-lock-file
      '')
      (writeShellScriptBin "notify" ''
        cmd="$*"

        if [ ''${#cmd} -gt 15 ]; then
            name="''${cmd:0:12}..."
        else
            name="''$cmd"
        fi

        eval "''$cmd"
        exit_code=''$?

        if [ ''$exit_code -eq 0 ]; then
            ${libnotify}/bin/notify-send "$name done!"
        else
            ${libnotify}/bin/notify-send "$name failed with exit ''$exit_code."
        fi
      '')
    ]
  );
}
