{ pkgs, config, inputs, lib, ... }:
{
  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      ionos-password = {
        path = "/run/user/1000/secrets/ionos";
      };
    };
  };

  modules = {
    zsh.enable = true;
    librewolf.enable = true;

    labwc.enable = true;
  };

  programs = {
    vscode.enable = true;

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

        "lab0" = {
          hostname = "192.168.0.201";
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
        key = "D1912EEBC3FBEBB4";
      };
    };
  };

  home = {
    packages = (with pkgs; [
      signal-desktop-bin
      spotify
      (writeShellScriptBin "nrun" ''
        #!/usr/bin/env bash
        nix run nixpkgs#$1 
      '')
    ]);
  };
}
