{
  pkgs,
  config,
  ...
}:
{
  sops = {
    age = {
      keyFile = "/persist/home/marrero/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets.ssh.path = "/run/user/1000/secrets/ssh";
  };

  modules = {
    zsh.enable = true;
    librewolf.enable = true;
    river.enable = true;

    waybar = {
      enable = true;
      mobile = true;
    };

    irssi = {
      enable = true;
      user = "fxttr";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    zed-editor.enable = true;

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

        "workstation" = {
          hostname = "192.168.0.200";
          user = "marrero";
          hashKnownHosts = true;
          forwardAgent = false;
          compression = false;
          forwardX11 = false;
          forwardX11Trusted = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 2;
          controlPersist = "no";
          identityFile = config.sops.secrets.ssh.path;
        };
      };
    };

    git = {
      enable = true;
      userName = "Florian Marrero Liestmann";
      userEmail = "f.m.liestmann@fx-ttr.de";
      ignores = [
        ".direnv/"
        ".cache/"
      ];

      extraConfig = {
        core = {
          editor = "hx";
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
    obsidian
  ];
}
