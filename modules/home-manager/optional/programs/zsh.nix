{
  pkgs,
  lib,
  config,
  ...
}:


let
  cfg = config.modules.zsh;

in
{
  options.modules.zsh.enable = lib.mkEnableOption "Install and configure irssi";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      enableCompletion = true;

      sessionVariables = {
        GPG_TTY = "$(tty)";
        FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
        FZF_CTRL_T_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
      };

      initContent = ''
	export PROMPT="%~ $ "
        source <(fzf --zsh)
      '';
    };
  };
}
