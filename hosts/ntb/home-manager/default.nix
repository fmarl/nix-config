{ pkgs, config, inputs, lib, ... }: {
  sops = {
    age = {
      keyFile = "/persist/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = { ssh = { path = "/run/user/1000/secrets/ssh"; }; };
  };

  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    neovim.enable = true;

    irssi = {
      enable = true;
      user = "fxttr";
    };

    river.enable = true;
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
      };
    };

    git = {
      enable = true;
      userName = "Florian Marrero Liestmann";
      userEmail = "f.m.liestmann@fx-ttr.de";
      ignores = [ ".direnv/" ".cache/" ];

      extraConfig = {
        core = {
          editor = "nvim";
          whitespace = "-trailing-space";
        };
        log = { abbrevCommit = true; };
        pull = { rebase = false; };
      };

      signing = {
        signByDefault = false;
        key = "D1912EEBC3FBEBB4";
      };
    };
  };

  home.packages = (with pkgs; [
    signal-desktop-bin
    spotify
    (writeShellScriptBin "nrun" ''
      NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$1
    '')
    (writeShellScriptBin "metaflake" ''
      nix develop github:flmarrero/metaflakes#$1 --no-write-lock-file
    '')
  ]);
}
