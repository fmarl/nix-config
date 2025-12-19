{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh.enable = mkEnableOption "Install and configure zsh";

  config = mkIf cfg.enable {
    programs = {
      starship.enable = true;
      
      zsh = {
        enable = true;
        syntaxHighlighting.enable = false;
        autocd = true;
        enableCompletion = true;

        shellAliases = {
          switch = "sudo darwin-rebuild switch --flake .";
        };

        sessionVariables = {
          OWL_DB = "/Users/florian.marreroliestmann/Documents/Lxo.kdbx";
          GPG_TTY = "$(tty)";
          FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --global '!.cache'";
          FZF_CTRL_T_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
          SECEN = "$HOME/Devel/SecEn/";
          INFRA = "$HOME/Devel/Infra/";
          PRIV = "$HOME/Devel/Priv/";
        };

        initContent = ''
	  PROMPT='%~ $ '

          if [ -n "''${commands[fzf-share]}" ]; then
                  source "$(fzf-share)/key-bindings.zsh"
                  source "$(fzf-share)/completion.zsh"
          fi

          if [ $(ps -ef | grep "ssh-agent" | grep -v "grep" | wc -l) -eq 0 ]; then
              eval `ssh-agent -s` > /dev/null
              echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$HOME/.ssh/agent.env"
              echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$HOME/.ssh/agent.env"
              chmod 600 "$HOME/.ssh/agent.env"
          else
              source "$HOME/.ssh/agent.env" > /dev/null
          fi

          if ! ssh-add -l &>/dev/null; then
               ssh-add -t 1d ~/.ssh/default
          fi

	  [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/zsh"
        '';
      };
    };
  };
}
