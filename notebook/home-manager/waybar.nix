{ pkgs, config, lib, ... }:
let
  colorscheme = import ./colors.nix;
in
{
  home.packages = with pkgs; [
    inter
  ];

  programs.waybar =
    {
      enable = true;
      settings = [{
        height = 10;
        modules-left = [ "sway/workspaces" ];
        modules-center = [ ];
        modules-right = [
          "tray"
          "network"
          "memory"
          "cpu"
          "battery"
          "disk"
          "clock"
        ];
        "sway/workspaces" = {
          all-outputs = true;
          disable-scroll = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            urgent = "";
            default = "";
          };
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%a %d.%m %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        disk = {
          interval = 5;
          format = "";
          format-alt = "{percentage_used:2}% ";
          path = "/";
        };

        tray = {
          spacing = 10;
        };

        cpu = {
          format = "";
          format-alt = "{usage}% ";
        };

        memory = {
          format = "";
          format-alt = "{}% ";
        };

        battery = {
          bat = "BAT0";
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{capacity}% {time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          format-wifi = "";
          format-ethernet = "";
          format-linked = "(No IP) ";
          format-disconnected = "";
          format-alt = "{bandwidthDownBits}/{bandwidthUpBits} ({signalStrength}%) ";
        };
      }];
      style = ''
        * {
            font-family: "Inter";
            font-size: 14px;
            color: #FFFFFF;
        }

        #waybar {
            background: linear-gradient(0deg, rgba(28, 28, 30, 0.5) 0%, rgba(28, 28, 30, 0.85) 100%);
            transition: background .2s ease-out;
            padding: 5px 0;
        }

        #workspaces button {
            padding: 0 8px;
            color: #F0F0F0;
            margin: 0 2px;
        }

        #workspaces button.focused {
            background: linear-gradient(0deg, rgba(28, 28, 30, 0.65) 0%, rgba(28, 28, 30, 1) 100%);
        }

        #workspaces button:hover {
            background: linear-gradient(0deg, rgba(28, 28, 30, 0.65) 0%, rgba(28, 28, 30, 1) 100%);
        }

        #clock,
        #network,
        #memory,
        #cpu,
        #battery,
        #disk {
            padding: 0 10px;
            margin: 0 2px;
        }

        #tray {
            padding: 0 5px;
        }
      '';
    };
}
