{ pkgs, config, ... }:
let
  colorscheme = import ./colors.nix;
  fontConf = {
    names = [ "Source Code Pro" ];
    size = 11.0;
  };
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      fonts = fontConf;
      
      startup = [
        {
          command =
            let lockCmd = "swaylock -f";
            in
              ''swayidle -w \
              timeout 600 ${lockCmd} \
              timeout 1200 'swaymsg "output * dpms off"' \
                      resume 'swaymsg "output * dpms on"' \
                     before-sleep ${lockCmd}
              '';
        }
      ];
      
      input."type:keyboard".xkb_layout = "de";

      bars = [{
        statusCommand = "${pkgs.i3status}/bin/i3status";
        command = "${pkgs.sway}/bin/swaybar";
        position = "top";
        fonts = fontConf;
        trayOutput = "*";
        colors = {
          background = "#${colorscheme.dark.bg_0}";
          statusline = "#${colorscheme.dark.fg_0}";
          separator = "#${colorscheme.dark.fg_0}";
          focusedWorkspace = {
            border = "#${colorscheme.dark.bg_1}";
            background = "#${colorscheme.dark.bg_2}";
            text = "#${colorscheme.dark.fg_1}";
          };
          activeWorkspace = {
            border = "#${colorscheme.dark.bg_0}";
            background = "#${colorscheme.dark.bg_1}";
            text = "#${colorscheme.dark.fg_1}";
          };
          inactiveWorkspace = {
            border = "#${colorscheme.dark.bg_0}";
            background = "#${colorscheme.dark.bg_0}";
            text = "#${colorscheme.dark.dim_0}";
          };
          urgentWorkspace = {
            border = "#${colorscheme.dark.bg_1}";
            background = "#${colorscheme.dark.red}";
            text = "#${colorscheme.dark.fg_1}";
          };
        };
      }];

      colors = {
          focused = {
            border = "#${colorscheme.dark.green}";
            background = "#${colorscheme.dark.green}";
            text = "#${colorscheme.dark.bg_0}";
            indicator = "#${colorscheme.dark.green}";
            childBorder = "#${colorscheme.dark.green}";
          };
          focusedInactive = {
            border = "#${colorscheme.dark.bg_1}";
            background = "#${colorscheme.dark.bg_1}";
            text = "#${colorscheme.dark.fg_0}";
            indicator = "#${colorscheme.dark.bg_1}";
            childBorder = "#${colorscheme.dark.bg_1}";
          };
          unfocused = {
            border = "#${colorscheme.dark.bg_0}";
            background = "#${colorscheme.dark.bg_0}";
            text = "#${colorscheme.dark.dim_0}";
            indicator = "#${colorscheme.dark.bg_0}";
            childBorder = "#${colorscheme.dark.bg_0}";
          };
          urgent = {
            border = "#${colorscheme.dark.red}";
            background = "#${colorscheme.dark.red}";
            text = "#${colorscheme.dark.fg_1}";
            indicator = "#${colorscheme.dark.red}";
            childBorder = "#${colorscheme.dark.red}";
          };
        };

      menu = "bemenu-run -m all --fn 'Source Code Pro 14' --nb '#${colorscheme.dark.bg_0}' --ab '#${colorscheme.dark.bg_0}' --fb '#${colorscheme.dark.bg_0}' --tb '#${colorscheme.dark.bg_0}' --sb '#${colorscheme.dark.bg_0}' --hb '#${colorscheme.dark.bg_0}' --tf '#${colorscheme.dark.fg_0}' --hf '#${colorscheme.dark.red}' --no-exec | xargs swaymsg exec --";

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          inherit (config.wayland.windowManager.sway.config)
            left down up right menu terminal;
        in
          {
            "${mod}+Shift+Return" = "exec ${terminal}";
            "${mod}+Shift+q" = "kill";
            "${mod}+p" = "exec ${menu}";
            "${mod}+Shift+d" = "exec ${terminal} -e ranger";
            "${mod}+l" = "exec swaylock";

            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";

            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";

            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 10";

            "${mod}+h" = "split h";
            "${mod}+v" = "split v";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+comma" = "layout stacking";
            "${mod}+period" = "layout tabbed";
            "${mod}+slash" = "layout toggle split";
            "${mod}+a" = "focus parent";
            "${mod}+s" = "focus child";

            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
          };
    };
  };
}
