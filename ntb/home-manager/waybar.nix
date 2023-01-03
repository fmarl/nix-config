{ pkgs, lib, ... }:
let
  colorscheme = import ./colors.nix;
in
{
  programs.waybar =
    {
      enable = true;
      settings = [{
        height = 10;
        modules-left = [ "sway/workspaces" ];
        modules-center = [];
        modules-right = [ "tray" "network" "memory" "cpu" "battery" "clock" ];
        "sway/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "9" = "";
            "10" = "";
            focused = "";
            urgent = "";
            default = "";
          };
        };
        tray = {
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %d %b}";
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        battery = {
          bat = "bat0";
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Ethernet ";
          format-linked = "Ethernet (No IP) ";
          format-disconnected = "Disconnected ";
          format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
        };
      }];
      style = ''
          #workspaces button,
          #tray,
          #network,
          #memory,
          #cpu,
          #battery,
          #clock,
          #custom-power {
              background: #${colorscheme.dark.bg_0};
              color: #${colorscheme.dark.fg_0};
          }

          #workspaces button:hover {
              background: #${colorscheme.dark.bg_0};
          }

          #workspaces button.focused {
              background: #${colorscheme.dark.bg_1};
              color: #${colorscheme.dark.fg_1};
          }

          #network.disconnected {
              background: #${colorscheme.dark.bg_1};
              color: #${colorscheme.dark.fg_1};
          }

          #battery.charging {
              background: #${colorscheme.dark.green};
              color: #${colorscheme.dark.green};
          }

          #workspaces button.urgent,
          #battery.critical:not(.charging) {
              background: #${colorscheme.dark.red};
              color: #${colorscheme.dark.red};
          }

          tooltip {
              background: #${colorscheme.dark.bg_1};
              box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
          }
          
          tooltip * {
              color: #${colorscheme.dark.fg_0};
          }
        '';
    };
}
