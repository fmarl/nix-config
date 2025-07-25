{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  wallpaper = cfg.wallpaper;
  colorscheme = import ./../../colors.nix;
  fontConf = {
    names = [ "Source Code Pro" ];
    size = 11.0;
  };

  cfg = config.modules.i3;
in
{
  options.modules.i3.enable = mkEnableOption "Install and configure i3";

  options.modules.i3.wallpaper = mkOption {
    type = types.str;
    description = "Set the wallpaper";
    default = "";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.feh
      pkgs.ranger
      pkgs.dmenu
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        colors.primary = {
          background = "#${colorscheme.dark.bg_0}";
          foreground = "#${colorscheme.dark.fg_0}";
          dim_foreground = "#${colorscheme.dark.dim_0}";
        };

        colors.normal = {
          black = "#636363";
          red = "#${colorscheme.dark.red}";
          green = "#${colorscheme.dark.green}";
          yellow = "#${colorscheme.dark.yellow}";
          blue = "#${colorscheme.dark.blue}";
          magenta = "#${colorscheme.dark.magenta}";
          cyan = "#${colorscheme.dark.cyan}";
          white = "#f7f7f7";
        };

        colors.bright = {
          black = "#636363";
          red = "#${colorscheme.dark.br_red}";
          green = "#${colorscheme.dark.br_green}";
          yellow = "#${colorscheme.dark.br_yellow}";
          blue = "#${colorscheme.dark.br_blue}";
          magenta = "#${colorscheme.dark.br_magenta}";
          cyan = "#${colorscheme.dark.br_cyan}";
          white = "#f7f7f7";
        };
      };
    };

    services.polybar = {
      enable = true;
      config = ./polybar/config.ini;
      script = "polybar mainBar &";
    };

    xsession.windowManager.i3 = {
      enable = true;

      extraConfig = ''
        default_border pixel 1
        default_floating_border pixel 1
        for_window [ class="^.*" ] border pixel 1
      '';

      config = {
        modifier = "Mod4";
        floating.modifier = "Mod4";
        terminal = "alacritty";
        fonts = fontConf;

        workspaceOutputAssign = [
          {
            workspace = "1";
            output = "HDMI-1";
          }
          {
            workspace = "2";
            output = "HDMI-1";
          }
          {
            workspace = "3";
            output = "HDMI-1";
          }
          {
            workspace = "4";
            output = "HDMI-1";
          }
          {
            workspace = "5";
            output = "HDMI-1";
          }
          {
            workspace = "6";
            output = "DP-3";
          }
          {
            workspace = "7";
            output = "DP-3";
          }
          {
            workspace = "8";
            output = "DP-3";
          }
          {
            workspace = "9";
            output = "DP-3";
          }
          {
            workspace = "10";
            output = "DP-3";
          }
        ];

        bars = [ ];

        startup = [
          {
            command = "systemctl --user restart polybar";
            always = true;
            notification = false;
          }
          {
            command = "feh --bg-tile ${wallpaper} &";
            always = true;
            notification = true;
          }
        ];

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

        menu = "${pkgs.dmenu}/bin/dmenu_run -nb #${colorscheme.dark.bg_0} -sb #${colorscheme.dark.bg_0} -sf #${colorscheme.dark.green}";

        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
            inherit (config.xsession.windowManager.i3.config) menu terminal;
          in
          {
            "${mod}+Shift+Return" = "exec ${terminal}";
            "${mod}+Shift+c" = "kill";
            "${mod}+p" = "exec ${menu}";
            "${mod}+Shift+d" = "exec ${terminal} -e ranger";

            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";

            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";

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

            "${mod}+Shift+f" = "fullscreen toggle";
            "${mod}+Shift+s" = "layout stacking";
            "${mod}+Shift+t" = "layout tabbed";
            "${mod}+t" = "layout toggle split";
            "${mod}+a" = "focus parent";
            "${mod}+s" = "focus child";

            "${mod}+r" = "reload";
            "${mod}+Shift+r" = "restart";
          };
      };
    };
  };
}
