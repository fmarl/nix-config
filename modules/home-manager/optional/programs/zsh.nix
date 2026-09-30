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
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      enableCompletion = true;

      history = {
        ignoreAllDups = true;
        saveNoDups = true;
        findNoDups = true;
      };

      initContent = ''
        export PROMPT="%~ ''${''${SHLVL:#1}:+[$((SHLVL-1))] }λ "
      '';
    };
  };
}
