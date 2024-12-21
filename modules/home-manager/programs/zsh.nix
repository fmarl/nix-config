{ pkgs, lib, config, nixosConfigurations, ... }:

with lib;

let cfg = config.modules.zsh;

in {
  options.modules.zsh.enable = mkEnableOption "Install and configure irssi";

  config = mkIf cfg.enable {
    programs.zsh = {
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
    };
  };
}
