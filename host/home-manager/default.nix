{
  config,
  pkgs,
  vars,
  ...
}:

let
  mkGitHost = host: {
    hostname = host;
    user = "git";
    hashKnownHosts = true;
    forwardAgent = false;
    compression = false;
    forwardX11 = false;
    forwardX11Trusted = false;
    serverAliveInterval = 0;
    serverAliveCountMax = 1;
    controlPersist = "no";
    identityFile = "${config.home.homeDirectory}/.ssh/default";
  };
in
{
  modules = {
    zsh.enable = true;
    owl.enable = true;
    hawk.enable = true;
    emacs.enable = true;
    helix.enable = true;

    envs = {
      python.enable = true;
      go.enable = true;
      lisp.enable = true;
      ocaml.enable = true;
      clojure.enable = true;
      rust.enable = true;
      java.enable = true;
      node.enable = true;
      terraform.enable = true;
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "bitbucket.org" = mkGitHost "bitbucket.org";
        "github.com" = mkGitHost "github.com";
      };
    };

    git = {
      enable = true;
      ignores = [
        ".direnv/"
        ".cache/"
        ".envrc"
      ];

      signing = {
        signByDefault = true;
        key = vars.git.signingKey;
      };

      settings = {
        user = {
          inherit (vars.git) name email;
        };

        core = {
          editor = "hx";
          whitespace = "-trailing-space";
        };

        init.defaultBranch = "main";
        log.abbrevCommit = true;
        pull.rebase = false;
      };
    };
  };

  home.packages = with pkgs; [
    insomnia
    awscli2
    gitleaks
  ];

  home.stateVersion = "25.05";
}
