{ pkgs, config, inputs, lib, ... }: {
  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = { ssh = { path = "/run/user/1000/secrets/ssh"; }; };
  };

  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    neovim.enable = true;
    gnome.enable = true;
  };

  programs = {
    vscode.enable = true;
    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 100000;
      extraConfig = ''
        set -g mouse on
      '';
    };

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
      signing = {
        signByDefault = false;
        key = "D1912EEBC3FBEBB4";
      };
    };
  };

  home = {
    packages = (with pkgs; [
      signal-desktop-bin
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
    ]);
  };
}
