{
  pkgs,
  ...
}:
{
  modules = {
    zsh.enable = true;
    owl.enable = true;
    emacs.enable = true;
    lf.enable = true;
    tmux.enable = true;
    helix.enable = true;

    envs = {
      python.enable = true;
      go.enable = true;
      java.enable = true;
      ocaml.enable = true;
      clojure.enable = true;
      rust.enable = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    zoxide.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "bitbucket.org" = {
          hostname = "bitbucket.org";
          user = "git";
          hashKnownHosts = true;
          forwardAgent = false;
          compression = false;
          forwardX11 = false;
          forwardX11Trusted = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 1;
          controlPersist = "no";
          identityFile = "/Users/florian.marreroliestmann/.ssh/default";
        };

        "github.com" = {
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
          identityFile = "/Users/florian.marreroliestmann/.ssh/default";
        };
      };
    };

    git = {
      enable = true;
      userName = "Florian Marrero Liestmann";
      userEmail = "florian.marreroliestmann@haufe-lexware.net";
      ignores = [
        ".direnv/"
        ".cache/"
        ".envrc"
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
        signByDefault = true;
        key = "36B8D5836D784D51";
      };
    };
  };

  home.packages = with pkgs; [
    insomnia
    awscli2
  ];

  home.stateVersion = "25.05";
}
