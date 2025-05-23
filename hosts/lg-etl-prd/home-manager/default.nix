{ config, pkgs, lib, ... }: {
  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = { ssh = { path = "/run/user/1001/secrets/ssh"; }; };
  };

  modules = {
    zsh.enable = true;
    neovim.enable = true;
  };

  programs = {
    home-manager.enable = true;

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

        "lg-ai-accel01" = {
          hostname = "10.100.48.11";
          user = "pideu";
          identityFile = config.sops.secrets.ssh.path;
        };

        "bitbucket" = {
          hostname = "www.pideu.de";
          user = "git";
          port = 7999;
          identityFile = config.sops.secrets.ssh.path;
        };
      };
    };

    git = {
      enable = true;
      userName = "Florian Marrero Liestmann";
      userEmail = "florian.buestgens@eu.panasonic.com";
      ignores = [ ".direnv/" ".cache/" ];

      extraConfig = {
        core = {
          editor = "nvim";
          whitespace = "-trailing-space";
        };
        log = { abbrevCommit = true; };
        pull = { rebase = false; };
      };
    };
  };

  home = {
    packages = (with pkgs; [
      (writeShellScriptBin "nrun" ''
        NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$1
      '')
      (writeShellScriptBin "metaflake" ''
        nix develop github:flmarrero/metaflakes#$1 --no-write-lock-file
      '')
    ]);

    sessionVariables = { EDITOR = "nvim"; };
  };

}
