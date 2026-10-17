{
  lib,
  ...
}:
let
  # host: over SSH, the directory, the git branch and action, the shell depth,
  # the exit status if it failed, # for root. Expanded on every prompt.
  prompt = lib.concatStrings [
    "\${SSH_CONNECTION:+%m:}%~\${vcs_info_msg_0_} "
    "\${\${SHLVL:#1}:+[$((SHLVL-1))] }"
    "%(?..%F{red}%? %f)"
    "%(!.%F{red}#%f.λ) "
  ];
in
{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;

    # Rebuild the completion dump at most once a day
    completionInit = ''
      autoload -U compinit
      () {
          setopt LOCAL_OPTIONS EXTENDED_GLOB
          if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
              compinit
          else
              compinit -C
          fi
      }
    '';

    history = {
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = true;
    };

    initContent = ''
      autoload -Uz vcs_info add-zsh-hook

      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git:*' formats ' %F{blue}%b%f'
      zstyle ':vcs_info:git:*' actionformats ' %F{blue}%b%f|%F{yellow}%a%f'

      add-zsh-hook precmd vcs_info

      setopt PROMPT_SUBST
      PROMPT=${lib.escapeShellArg prompt}
    '';
  };
}
