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
    swm = {
      enable = true;
      wallpaper = "${inputs.media}/Yosemite 3.jpg";
    };
  };

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
        "codeberg" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = config.sops.secrets.ssh.path;
        };
        "rpi" = {
          hostname = "192.168.0.4";
          user = "florian";
          identityFile = config.sops.secrets.ssh.path;
        };
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

  home = {
    packages = (with pkgs; [
      spotify
      signal-desktop
      ranger
    ]);
  };
}
