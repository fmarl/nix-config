{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  colorscheme = import ./../../colors.nix;
  cfg = config.modules.labwc;
in
{
  options.modules.labwc.enable = mkEnableOption "Install and configure labwc";

  config = mkIf cfg.enable
    {
      programs = {
        alacritty.enable = true;
        bemenu.enable = true;
        ranger.enable = true;
        zathura.enable = true;
        mpv.enable = true;
        imv.enable = true;
      };

      home = {
        packages = (with pkgs; [
          wl-clipboard
        ]);
      };

      services = {
        mako = {
          enable = true;

          backgroundColor = "#${colorscheme.dark.bg_2}";
          borderColor = "#${colorscheme.dark.bg_1}";
          borderRadius = 12;
          progressColor = "#${colorscheme.dark.br_cyan}";
        };

        conky = {
          enable = true;

          extraConfig = ''
conky.config = {
    alignment = 'top_left',
    background = false,
    border_width = 0,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'Fira Code:size=12',
    forced_redraw = true,
    no_buffers = true,
    format_human_readable = true,
    net_avg_samples = 2,
    out_to_x = false,
    out_to_wayland = true,
    own_window = true,
    own_window_argb_visual = true,
    own_window_argb_value = 255,
    own_window_color = blue,
    own_window_class = 'Conky',
    own_window_type = 'dock',
    own_window_hints = 'below,sticky,skip_taskbar,undecorated,skip_pager',
    own_window_transparent = true,
    override_utf8_locale = true,
    show_graph_range = false,
    show_graph_scale = false,
    update_interval = 1.0,
    uppercase = true,
    use_spacer = 'none',
    use_xft = true,
    xftalpha = 1.0,
}

conky.text = [[
''${color grey}Time $alignr''${color}''${time %d.%m.%Y %I:%M}

''${color grey}CPU $alignr''${color}$cpu%
''${color grey}''${cpugraph cpu0 25,260 #d4a8ff #d4a8ff}
''${color grey}Freq $alignr''${color}$freq_g Ghz

''${color grey}RAM$alignr''${color}$mem / $memmax
''${color #BEC8CB}''${membar 5}

''${color grey}FS$alignr''${color}''${fs_used /nix} / ''${fs_size /nix}
''${color #BEC8CB}''${fs_bar /nix}

''${color grey}Battery ''${font IBM Plex Mono:size=11:Bold}''${alignr}''${color}''${if_existing /sys/class/power_supply/BAT0/status Charging}''${color #7CFC00}Charging''${else}''${if_existing /sys/class/power_supply/BAT0/status Discharging}''${color #ffd000}Discharging''${else}''${if_existing /sys/class/power_supply/BAT0/status Not charging}''${color #e46600}Full''${endif}''${endif}''${endif}''${color grey} ~ ''${color}''${battery_percent}%
''${color #BEC8CB}''${battery_bar 5}

''$alignc''${color grey}Network
''$alignc''${if_up usb0}''${color #00a558}USB''${else}''${if_existing /proc/net/route wlan0}''${color #49A3FC}''${wireless_essid wlan0} [WIFI]''${else}''${color #e66529}Not Connected''${endif}''${endif}
''${if_up usb0}''${color grey}Up''${goto 143.5}''${color grey}Down
''${color #BEC8CB}''${upspeedgraph usb0 25,120 #ffd4a8 #ffd4a8}''${alignr}''${downspeedgraph usb0 25,120 #a8ffa8 #a8ffa8}
''${color grey}''${upspeedf usb0} kib/s''${goto 143.5}''${color grey}''${downspeedf usb0} kib/s
''${endif}''${if_existing /proc/net/route wlan0}
''${color grey}Up''${goto 143.5}''${color grey}Down
''${color #BEC8CB}''${upspeedgraph wlan0 25,120 #ffd4a8 #ffd4a8}''${alignr}''${downspeedgraph wlan0 25,120 #a8ffa8 #a8ffa8}
''${color grey}''${upspeedf wlan0} kib/s''${goto 143.5}''${color grey}''${downspeedf wlan0} kib/s
''${endif}
]]
          '';
        };
      };
    };
}
