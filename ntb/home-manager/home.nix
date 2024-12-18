{ pkgs, config, inputs, lib, ... }:
{
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
    theme.enable = true;
    irssi.enable = true;
    sway = {
      enable = true;
      wallpaper = "${inputs.media}/Yosemite 3.jpg";
    };
    
    waybar = {
      enable = true;
      mobile = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    firefox = {
      enable = true;
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
      signing = {
        signByDefault = false;
        key = "970E99190402423AEDDC82B9D5F3F8665AD2BEEB";
      };
    };
  };

  home = {
    username = "marrero";
    homeDirectory = "/home/marrero";
    stateVersion = "25.05";

    packages = (with pkgs; [
      signal-desktop
      dbeaver-bin
      spotify
    ]);
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
