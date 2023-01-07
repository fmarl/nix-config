{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
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
    };

    shellAliases = {
      ll = "ls -l";
    };
  };
}
