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
      svc = {
        path = "/run/user/1000/secrets/svc";
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
    zsh.enable = true;
    emacs.enable = true;
    theme.enable = true;
    swm.enable = true;
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
        "svc" = {
          hostname = "192.168.0.2";
          user = "florian";
          identityFile = config.sops.secrets.svc.path;
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
      nixpkgs-fmt
      speedcrunch
      rnix-lsp
      signal-desktop
      discord
    ]);
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
