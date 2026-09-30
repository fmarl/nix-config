{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.waybar;
  c = (import ../../colors.nix).dark;

  segment = module: [
    "custom/left-arrow-dark"
    module
    "custom/left-arrow-light"
  ];

  storage = if cfg.zfsPool != null then "custom/zpool" else "disk";

  calendarTooltip = ''
    <big>{:%Y %B}</big>
    <tt><small>{calendar}</small></tt>'';

  arrow = glyph: {
    format = glyph;
    tooltip = false;
  };
in
{
  options.modules.waybar = {
    enable = lib.mkEnableOption "Install and configure waybar";

    mobile = lib.mkOption {
      type = lib.types.bool;
      description = "Enable a smaller version of waybar for mobile devices";
      default = false;
    };

    zfsPool = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Show the capacity of this ZFS pool instead of the usage of /";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = [
        (
          {
            modules-left = [
              "niri/workspaces"
              "custom/right-arrow-dark"
              "niri/window"
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
              lib.concatMap segment [
                "idle_inhibitor"
                "network"
                "wireplumber"
                "memory"
                "cpu"
                (if cfg.mobile then "battery" else storage)
              ]
              ++ [
                "custom/left-arrow-dark"
                "tray"
              ];

            "custom/left-arrow-dark" = arrow "";
            "custom/left-arrow-light" = arrow "";
            "custom/right-arrow-dark" = arrow "";
            "custom/right-arrow-light" = arrow "";

            "niri/window" = {
              max-length = 60;
            };

            "clock#1" = {
              format = "{:%a}";
              tooltip-format = calendarTooltip;
            };
            "clock#2" = {
              format = "{:%H:%M}";
              tooltip-format = calendarTooltip;
            };
            "clock#3" = {
              format = "{:%d.%m}";
              tooltip-format = calendarTooltip;
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
            };

            wireplumber = {
              format = "{volume}% {icon}";
              format-muted = "";
              format-icons = [
                ""
                ""
                ""
              ];
              on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
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
          // lib.optionalAttrs (cfg.zfsPool != null) {
            "custom/zpool" = {
              exec = "/run/current-system/sw/bin/zpool list -H -o cap ${cfg.zfsPool}";
              interval = 60;
              format = "Disk {}";
              tooltip = false;
            };
          }
        )
      ];
      style = ''
        * {
          font-size: 18px;
          font-family: "Aporetic Sans Mono";
        }

        window#waybar {
          background: #${c.bg_0};
          color: #${c.fg_0};
        }

        #custom-right-arrow-dark,
        #custom-left-arrow-dark {
          color: #${c.bg_1};
        }

        #custom-right-arrow-light,
        #custom-left-arrow-light {
          color: #${c.bg_0};
          background: #${c.bg_1};
        }

        #workspaces,
        #clock.1,
        #clock.2,
        #clock.3,
        #idle_inhibitor,
        #network,
        #wireplumber,
        #memory,
        #cpu,
        #battery,
        #disk,
        #custom-zpool,
        #tray {
          background: #${c.bg_1};
        }

        #workspaces button {
          padding: 0 2px;
          color: #${c.fg_0};
        }

        #workspaces button.active,
        #workspaces button.focused {
          color: #${c.br_blue};
        }

        #workspaces button.urgent {
          color: #${c.red};
        }

        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          background: #${c.bg_1};
          border: #${c.bg_1};
          padding: 0 3px;
        }

        #window {
          color: #${c.dim_0};
          padding: 0 10px;
        }

        #idle_inhibitor {
          color: #${c.dim_0};
        }

        #idle_inhibitor.activated {
          color: #${c.br_yellow};
        }

        #network {
          color: #${c.blue};
        }

        #wireplumber {
          color: #${c.magenta};
        }

        #wireplumber.muted {
          color: #${c.dim_0};
        }

        #memory {
          color: #${c.br_cyan};
        }

        #cpu {
          color: #${c.violet};
        }

        #battery {
          color: #${c.green};
        }

        #battery.warning {
          color: #${c.yellow};
        }

        #battery.critical {
          color: #${c.red};
        }

        #disk,
        #custom-zpool {
          color: #${c.yellow};
        }

        #clock,
        #idle_inhibitor,
        #network,
        #wireplumber,
        #memory,
        #cpu,
        #battery,
        #disk,
        #custom-zpool {
          padding: 0 10px;
        }
      '';
    };
  };
}
