{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.zsh;

in
{
  options.modules.zsh.enable = mkEnableOption "Install and configure irssi";

  config = mkIf cfg.enable {
    programs.powerline-go = {
      enable = true;
      modules = [
        "cwd"
        "perms"
        "hg"
        "jobs"
        "exit"
        "newline"
        "ssh"
        "direnv"
        "venv"
        "root"
      ];
      modulesRight = [
        "git"
      ];
    };

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      enableCompletion = true;

      sessionVariables = {
        GPG_TTY = "$(tty)";
        FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
        FZF_CTRL_T_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      initContent = ''
        if [ -n "''${commands[fzf-share]}" ]; then
                source "$(fzf-share)/key-bindings.zsh"
                source "$(fzf-share)/completion.zsh"
        fi
      '';
    };
  };
}
