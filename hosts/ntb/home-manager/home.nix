{ pkgs, config, inputs, lib, ... }:
{
  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  modules = {
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
        signByDefault = true;
        key = "D1912EEBC3FBEBB4";
      };
    };
  };

  home = {
    packages = (with pkgs; [
      signal-desktop
      dbeaver-bin
      spotify
    ]);
  };
}
