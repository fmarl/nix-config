{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh.enable = lib.mkEnableOption "Install and configure zsh";

  config = lib.mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        syntaxHighlighting.enable = false;
        autocd = true;
        enableCompletion = true;

        shellAliases = {
          switch = ''sudo darwin-rebuild switch --flake "''${NIX_CONFIG_DIR:-$HOME/Devel/Priv/nix-config}"'';
          lx-claude = "$HOME/Devel/SecEn/lx-claude-code/lx-claude.py";
        };

        sessionVariables = {
          NIX_CONFIG_DIR = "$HOME/Devel/Priv/nix-config";
          OWL_DB = "$HOME/Documents/Lxo.kdbx";
          FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
          FZF_CTRL_T_COMMAND = "rg --files --hidden --glob '!.git' --glob '!.direnv' --glob '!.cache'";
          SECEN = "$HOME/Devel/SecEn/";
          INFRA = "$HOME/Devel/Infra/";
          PRIV = "$HOME/Devel/Priv/";
        };

        initContent = ''
                    export GPG_TTY=$(tty)
                    export PATH=$PATH:$HOME/.local/bin
		    export PROMPT="%~ ''${''${SHLVL:#1}:+[$((SHLVL-1))] }''${AWS_PROFILE:+[$AWS_PROFILE] }λ "

                               if [ -n "''${commands[fzf-share]}" ]; then
                                 source "$(fzf-share)/key-bindings.zsh"
                                 source "$(fzf-share)/completion.zsh"
                               fi

                               if ! ssh-add -l &>/dev/null; then
                                 eval $(ssh-agent -s) > /dev/null
                                 ssh-add -t 1d ~/.ssh/default
                               fi

                               ${builtins.readFile ./cc-worktree.zsh}
        '';
      };
    };
  };
}
