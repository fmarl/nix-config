{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.swm;
  wallpaper = cfg.wallpaper;
in
{
  options.modules.swm.enable = mkEnableOption "Install swm";

  options.modules.swm.wallpaper = mkOption {
    type = types.str;
    description = "Set the wallpaper";
    default = "";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          geometry = "300x60-15+46";
          indicate_hidden = "yes";
          shrink = "yes";
          transparency = 0;
          notification_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 3;
          frame_color = "#000000";
          separator_color = "frame";
          sort = "yes";
          idle_threshold = 120;
          font = "Source Code Pro1 12";
          line_height = 0;
          markup = "full";
          format = ''
            <b>%s</b>
            %b'';
          alignment = "left";
          show_age_threshold = 60;
          word_wrap = "yes";
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";
          icon_position = "left";
          max_icon_size = 32;
          sticky_history = "yes";
          history_length = 20;
          title = "Dunst";
          class = "Dunst";
          startup_notification = false;
          verbosity = "mesg";
          corner_radius = 8;
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action";
          mouse_right_click = "close_all";
        };

        urgency_low = {
          foreground = "#ffd5cd";
          background = "#121212";
          frame_color = "#181A20";
          timeout = 10;
        };

        urgency_normal = {
          background = "#121212";
          foreground = "#ffd5cd";
          frame_color = "#181A20";
          timeout = 10;
        };

        urgency_critical = {
          background = "#121212";
          foreground = "#ffd5cd";
          frame_color = "#181A20";
          timeout = 0;
        };
      };
    };

    home.packages = [
      pkgs.stc
      pkgs.feh
      pkgs.ranger
      pkgs.dmenu
    ];

    xsession = {
      enable = true;

      initExtra = ''
        set +x
        ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
        ${pkgs.xorg.xset}/bin/xset s off
        ${pkgs.xcape}/bin/xcape -e "Hyper_L=Tab;Hyper_R=backslash"
        ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option ctrl:nocaps
        ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}

        # Fix for Java apps
        export _JAVA_AWT_WM_NONREPARENTING=1
        ${pkgs.wmname}/bin/wmname "LG3D"
      '';

      windowManager.command = "${pkgs.swm}/bin/swm";
    };
  };
}
