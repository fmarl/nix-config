{ pkgs, config, inputs, lib, ... }:
{
  
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

      #github_token = {
      # path = "/run/user/1000/secrets/github_token";
      #};
    };
  };

  nix = {
    package = pkgs.nix;
    #settings = {
    #  extra-access-tokens = "!include ${config.sops.secrets.github_token.path}";
    #};
  };

  coco = {
    zsh.enable = true;
    theme.enable = true;
    irssi.enable = true;
    sway = {
	enable = true;
	wallpaper = "${inputs.media}/Yosemite 3.jpg";
    };
    waybar.enable = true;
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

    packages = (with pkgs; [
      firefox
      spotify
      nixpkgs-fmt
      cachix
      signal-desktop
      discord
      mpv
      ranger
    ]);
  };
}
