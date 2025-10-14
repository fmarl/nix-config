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
    emacs.enable = true;

    waybar = {
      enable = true;
      mobile = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    helix = {
      enable = true;

      settings = {
        theme = "autumn";

        editor = {
          bufferline = "multiple";
          cursorline = true;
          rulers = [ 120 ];
          true-color = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          lsp = {
            auto-signature-help = false;
            display-messages = true;
          };

          statusline = {
            left = [
              "mode"
              "spinner"
              "version-control"
              "file-name"
            ];
          };

          end-of-line-diagnostics = "hint";

          inline-diagnostics = {
            cursor-line = "error";
            other-lines = "disable";
          };
        };
      };
    };

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
