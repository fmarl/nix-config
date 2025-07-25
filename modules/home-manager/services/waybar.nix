{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.waybar;
in
{
  options.modules.waybar.enable = mkEnableOption "Install and configure waybar";
  options.modules.waybar.mobile = mkOption {
    type = types.bool;
    description = "Enable a smaller version of waybar for mobile devices";
    default = false;
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = [
        {
          height = 10;
          modules-left = [
            "river/tags"
            "custom/right-arrow-dark"
          ];
          modules-center = [
            "custom/left-arrow-dark"
            "clock#1"
            "custom/left-arrow-light"
            "custom/left-arrow-dark"
            "clock#2"
            "custom/right-arrow-dark"
            "custom/right-arrow-light"
            "clock#3"
            "custom/right-arrow-dark"
          ];
          modules-right =
            if cfg.mobile then
              [
                "custom/left-arrow-dark"
                "network"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "memory"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "cpu"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "battery"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "tray"
              ]
            else
              [
                "custom/left-arrow-dark"
                "network"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "memory"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "cpu"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "disk"
                "custom/left-arrow-light"
                "custom/left-arrow-dark"
                "tray"
              ];
          "river/tags" = {
            num-tags = 9;
          };
          "custom/left-arrow-dark" = {
            format = "";
            tooltip = false;
          };
          "custom/left-arrow-light" = {
            format = "";
            tooltip = false;
          };
          "custom/right-arrow-dark" = {
            format = "";
            tooltip = false;
          };
          "custom/right-arrow-light" = {
            format = "";
            tooltip = false;
          };
          "clock#1" = {
            format = "{:%a}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          "clock#2" = {
            format = "{:%H:%M}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          "clock#3" = {
            format = "{:%d.%m}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };

          disk = {
            interval = 5;
            format = "Disk {percentage_used:2}%";
            path = "/";
          };

          tray = {
            spacing = 10;
          };
          cpu = {
            format = "{usage}% ";
          };
          memory = {
            format = "{}% ";
          };
          battery = {
            bat = "BAT0";
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          network = {
            format-wifi = "({signalStrength}%) ";
            format-ethernet = "Ethernet ";
            format-linked = "Ethernet (No IP) ";
            format-disconnected = "Disconnected ";
            format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
          };
        }
      ];
      style = ''
        * {
        	font-size: 18px;
        	font-family: monospace;
        }

        window#waybar {
        	background: #2d2a2e;
        	color: #fdf6e3;
        }

        #custom-right-arrow-dark,
        #custom-left-arrow-dark {
        	color: #1a1a1a;
        }
        #custom-right-arrow-light,
        #custom-left-arrow-light {
        	color: #292b2e;
        	background: #1a1a1a;
        }

        #tags,
        #clock.1,
        #clock.2,
        #clock.3,
        #network,
        #memory,
        #cpu,
        #battery,
        #disk,
        #network,
        #tray {
        	background: #1a1a1a;
        }

        #tags button {
        	padding: 0 2px;
        	color: #fdf6e3;
        }
        #tags button.focused {
        	color: #268bd2;
        }
        #tags button:hover {
        	box-shadow: inherit;
        	text-shadow: inherit;
        }
        #tags button:hover {
        	background: #1a1a1a;
        	border: #1a1a1a;
        	padding: 0 3px;
        }

        #network {
        	color: #268bd2;
        }
        #memory {
        	color: #2aa198;
        }
        #cpu {
        	color: #6c71c4;
        }
        #battery {
        	color: #859900;
        }
        #disk {
        	color: #b58900;
        }

        #clock,
        #network,
        #memory,
        #cpu,
        #battery,
        #disk {
        	padding: 0 10px;
        }
      '';
    };
  };
}
