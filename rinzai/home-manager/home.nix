{ pkgs, config, inputs, lib, ... }:
{
  imports =
    [
      ./emacs
    ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      enableCompletion = true;

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];

      sessionVariables = {
        GPG_TTY = "$(tty)";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      shellAliases = {
        ll = "ls -l";
        nix-search = "nix search nixpkgs";
        nbuild = "sudo nixos-rebuild switch --flake .";
        hbuild = "home-manager switch --flake .";
      };
    };
  };

  home = {
    username = "florian";
    homeDirectory = "/home/florian";
    stateVersion = "22.11";

    file = {
      ".emacs.d" = {
        source = inputs.emacs-cfg;
        recursive = true;
      };
    };

    packages = (with pkgs; [
      cachix
    ]);
  };
}
