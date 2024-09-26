{ pkgs, config, inputs, lib, ... }:
{
  imports = [
    ./sway.nix
    ./waybar.nix
  ];

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = "${inputs.secrets}/systems/notebook.yaml";

    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      ssh = {
        path = "/run/user/1000/secrets/ssh";
      };
    };
  };

  coco = {
    zsh.enable = true;
    emacs.enable = true;
    theme.enable = true;
  };

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
        "rpi" = {
          hostname = "192.168.0.4";
          user = "marrero";
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
        key = "970E99190402423AEDDC82B9D5F3F8665AD2BEEB";
      };
    };
  };

  home = {
    username = "marrero";
    homeDirectory = "/home/marrero";
    stateVersion = "22.11";

    file = {
      ".emacs.d" = {
        source = inputs.emacs-cfg;
        recursive = true;
      };
    };

    packages = (with pkgs; [
      firefox
      nixpkgs-fmt
      signal-desktop
      dbeaver-bin
    ]);
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
