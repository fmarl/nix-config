{ pkgs, config, inputs, lib, ... }:
{
  imports =
    [
      ./sway.nix
    ];
  
  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = "${inputs.secrets}/systems/workstation.yaml";

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
    irssi.enable = true;
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
          identityFile = config.sops.secrets.ssh.path;
        };
        "codeberg" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = config.sops.secrets.ssh.path;
        };
        "svc" = {
          hostname = "192.168.0.2";
          user = "florian";
          identityFile = config.sops.secrets.ssh.path;
        };
        "rpi" = {
          hostname = "192.168.0.4";
          user = "florian";
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
        key = "70E8553E95661A5A46D5C5C8D7B81BF6241910A0";
      };
    };
  };

  home = {
    username = "marrero";
    homeDirectory = "/home/marrero";
    stateVersion = "24.05";

    file = {
      ".emacs.d" = {
        source = inputs.emacs-cfg;
        recursive = true;
      };
    };

    packages = (with pkgs; [
      firefox
      spotify
      nixpkgs-fmt
      cachix
      signal-desktop
      speedcrunch
      dbeaver-bin
      slack

      wl-clipboard
      alacritty
      bemenu
      imv
      mpv
      ranger
      zathura
    ]);
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
