{ pkgs, lib, config, nixosConfigurations, ... }:

with lib;

let cfg = config.modules.tmux;

in {
  options.modules.tmux.enable = mkEnableOption "Install and configure tmux";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 100000;
      plugins = with pkgs; [ tmuxPlugins.sensible ];
      extraConfig = ''
        # PREFIX \: Create a new vertial pane.
        bind \\ split-window -h

        # PREFIX -: Create a new horizontal pane.
        bind - split-window -v

        # Use Vim movement key mappings for switching around between panes.
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Use Vim movement key mappings (uppercase) for resizing panes.
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5
      '';
    };
  };
}
