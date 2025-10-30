{ pkgs, config, ... }:
{
  sops = {
    age = {
      keyFile = "/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets.ssh.path = "/run/user/1000/secrets/ssh";
  };

  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    river.enable = true;
    lf.enable = true;
    emacs.enable = true;
    waybar.enable = true;
  };

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "github" = {
          hostname = "github.com";
          user = "git";
          hashKnownHosts = true;
          forwardAgent = false;
          compression = false;
          forwardX11 = false;
          forwardX11Trusted = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 1;
          controlPersist = "no";
          identityFile = config.sops.secrets.ssh.path;
        };

        "codeberg" = {
          hostname = "codeberg.org";
          user = "git";
          hashKnownHosts = true;
          forwardAgent = false;
          compression = false;
          forwardX11 = false;
          forwardX11Trusted = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 1;
          controlPersist = "no";
          identityFile = config.sops.secrets.ssh.path;
        };
      };
    };

    git = {
      enable = true;
      
      ignores = [
        ".direnv/"
        ".cache/"
      ];

      settings = {
        user = {
          name = "Florian Marrero Liestmann";
          email = "f.m.liestmann@fx-ttr.de";
        };
        
        core = {
          editor = "emacsclient -c -a '' -w";
          whitespace = "-trailing-space";
        };
        
        log = {
          abbrevCommit = true;
        };
        
        pull = {
          rebase = false;
        };
      };

      signing = {
        signByDefault = false;
        key = "D1912EEBC3FBEBB4";
      };
    };
  };

  home.packages = with pkgs; [
    signal-desktop-bin
  ];
}
