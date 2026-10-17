{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  cfg = config.modules.waybar;
  inherit (theme) style;

  # Font Awesome Solid
  glyphs = {
    chevron-left = "f053";
    eye = "f06e";
    eye-slash = "f070";
    volume-xmark = "f6a9";
    volume-off = "f026";
    volume-low = "f027";
    volume-high = "f028";
    sun = "f185";
    charging-station = "f5e7";
    plug = "f1e6";
    battery-empty = "f244";
    battery-quarter = "f243";
    battery-half = "f242";
    battery-three-quarters = "f241";
    battery-full = "f240";
    wifi = "f1eb";
    network-wired = "f6ff";
    circle-xmark = "f057";
    hard-drive = "f0a0";
  };

  glyph = name: ''<span font_weight="900">${builtins.fromJSON "\"\\u${glyphs.${name}}\""}</span>'';

  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl --class=backlight set";

  statusModule =
    {
      name,
      config,
      color ? "fg_0",
      stateColors ? { },
      available ? true,
      pinned ? false,
    }:
    {
      inherit
        name
        config
        color
        stateColors
        available
        pinned
        ;
    };

  storage =
    if cfg.zfsPool != null then
      statusModule {
        name = "custom/zpool";
        config = {
          exec = "/run/current-system/sw/bin/zpool list -H -o cap ${cfg.zfsPool}";
          interval = 60;
          format = "{} ${glyph "hard-drive"}";
          tooltip = false;
        };
      }
    else
      statusModule {
        name = "disk";
        config = {
          interval = 30;
          format = "{percentage_used}% ${glyph "hard-drive"}";
          path = "/home";
        };
      };

  allStatusModules = [
    (statusModule {
      name = "idle_inhibitor";
      config = {
        format = "{icon}";
        format-icons = {
          activated = glyph "eye";
          deactivated = glyph "eye-slash";
        };
      };
      color = "dim_0";
      stateColors.activated = "br_blue";
    })
    (statusModule {
      name = "network";
      config = {
        format-wifi = "{signalStrength}% ${glyph "wifi"}";
        format-ethernet = "Ethernet ${glyph "network-wired"}";
        format-linked = "No IP ${glyph "network-wired"}";
        format-disconnected = glyph "circle-xmark";
        format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
      };
      stateColors.disconnected = "dim_0";
      pinned = true;
    })
    (statusModule {
      name = "wireplumber";
      config = {
        format = "{volume}% {icon}";
        format-muted = glyph "volume-xmark";
        format-icons = map glyph [
          "volume-off"
          "volume-low"
          "volume-high"
        ];
        on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      stateColors.muted = "dim_0";
    })
    (statusModule {
      name = "backlight";
      config = {
        format = "{percent}% ${glyph "sun"}";
        on-scroll-up = "${brightnessctl} +5%";
        on-scroll-down = "${brightnessctl} 5%-";
      };
      available = config.machine.laptop;
    })
    (statusModule {
      name = "battery";
      config = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ${glyph "charging-station"}";
        format-plugged = "{capacity}% ${glyph "plug"}";
        format-alt = "{time} {icon}";
        format-icons = map glyph [
          "battery-empty"
          "battery-quarter"
          "battery-half"
          "battery-three-quarters"
          "battery-full"
        ];
      };
      stateColors = {
        charging = "green";
        plugged = "green";
        warning = "yellow";
        critical = "red";
      };
      available = config.machine.laptop;
      pinned = true;
    })
    storage
  ];

  statusModules = lib.filter (m: m.available) allStatusModules;
  pinned = lib.filter (m: m.pinned) statusModules;
  drawer = lib.filter (m: !m.pinned) statusModules;
  names = map (m: m.name);

  selector = m: "#${lib.replaceStrings [ "/" ] [ "-" ] m.name}";

  calendarTooltip = ''
    <big>{:%Y %B}</big>
    <tt><small>{calendar}</small></tt>'';

  text = format: {
    inherit format;
    tooltip = false;
  };

  px = values: lib.concatMapStringsSep " " (n: "${toString n}px") values;
  hairline = "1px solid ${theme.rgba "fg_0" 0.1}";
  inset = 2;
  pillMargin = px [
    style.smallSpacing
    0
    style.smallSpacing
    style.spacing
  ];

  statusSelectors = map selector allStatusModules ++ [
    "#custom-expand"
    "#tray"
  ];

  moduleRules =
    m:
    ''
      ${selector m} {
        color: ${theme.color m.color};
      }
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (state: color: ''
        ${selector m}.${state} {
          color: ${theme.color color};
        }
      '') m.stateColors
    );
in
{
  options.modules.waybar.zfsPool = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    description = "Show the capacity of this ZFS pool instead of the usage of /home";
    default = null;
  };

  config = lib.mkIf config.machine.desktop {
    wayland.windowManager.niri.settings._children = [
      {
        layer-rule._children = [
          { match._props.namespace = "^waybar$"; }
          { block-out-from = "screencast"; }
        ];
      }
    ];

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = [
        (
          {
            height = style.barHeight;

            modules-left = [
              "niri/workspaces"
              "niri/window"
            ];
            "niri/window".max-length = 60;

            modules-center = [
              "clock#time"
              "custom/dot"
              "clock#date"
            ];

            modules-right = [ "group/status" ] ++ names pinned;
            "group/status" = {
              orientation = "inherit";
              drawer = {
                click-to-reveal = true;
                transition-left-to-right = false;
              };
              modules = [ "custom/expand" ] ++ names drawer ++ [ "tray" ];
            };

            "clock#time" = {
              format = "{:%H:%M}";
              align = 1.0;
              tooltip-format = calendarTooltip;
            };
            "custom/dot" = text "·";
            "clock#date" = {
              format = "{:%a %d %b}";
              align = 0.0;
              tooltip-format = calendarTooltip;
            };
            "custom/expand" = text (glyph "chevron-left");
            tray.spacing = 10;
          }
          // lib.listToAttrs (map (m: lib.nameValuePair m.name m.config) statusModules)
        )
      ];

      style = ''
        * {
          font-family: "${style.sansFont}", sans-serif;
          font-size: 13px;
          font-weight: 500;
          font-feature-settings: "tnum";
          border: none;
          border-radius: 0;
          min-height: 0;
          box-shadow: none;
          text-shadow: none;
        }

        window#waybar {
          background: ${theme.rgba "bg_0" 0.7};
          color: ${theme.color "fg_0"};
          border-bottom: ${hairline};
        }

        #workspaces {
          margin: ${pillMargin};
          padding: ${px [ inset ]};
          border-radius: ${px [ (style.smallCornerRadius + inset) ]};
          background: ${theme.rgba "fg_0" 0.07};
        }

        #workspaces button {
          margin: 0 1px;
          padding: ${
            px [
              0
              style.spacing
            ]
          };
          border-radius: ${px [ style.smallCornerRadius ]};
          color: ${theme.rgba "fg_0" 0.55};
          background: transparent;
          transition: background 200ms, color 200ms;
        }

        #workspaces button:hover {
          color: ${theme.color "fg_0"};
        }

        #workspaces button.active,
        #workspaces button.focused {
          color: ${theme.color "fg_0"};
          background: ${theme.color "bg_accent"};
          box-shadow: 0 1px 2px ${theme.rgba "fg_0" 0.18};
        }

        #workspaces button.urgent {
          color: ${theme.color "red"};
        }

        #window {
          padding: ${
            px [
              0
              style.largeSpacing
            ]
          };
          font-weight: 700;
        }

        #clock.time,
        #clock.date {
          min-width: 88px;
        }

        #clock.time {
          font-weight: 600;
        }

        #clock.date {
          color: ${theme.rgba "fg_0" 0.6};
        }

        #custom-dot {
          color: ${theme.rgba "fg_0" 0.3};
          padding: ${
            px [
              0
              style.smallSpacing
            ]
          };
        }

        ${lib.concatStringsSep ",\n" statusSelectors} {
          margin: ${
            px [
              style.smallSpacing
              1
            ]
          };
          padding: ${
            px [
              0
              style.spacing
            ]
          };
          border-radius: ${px [ style.smallCornerRadius ]};
          transition: background 200ms;
        }

        ${lib.concatMapStringsSep ",\n" (s: "${s}:hover") statusSelectors} {
          background: ${theme.rgba "fg_0" 0.08};
        }

        #tray {
          margin-right: ${px [ style.spacing ]};
        }

        ${lib.concatMapStrings moduleRules allStatusModules}
        #battery.critical {
          font-weight: 700;
        }

        #custom-expand {
          color: ${theme.rgba "fg_0" 0.35};
          transition: background 200ms, color 200ms;
        }

        #status:hover #custom-expand {
          color: ${theme.color "fg_0"};
        }

        tooltip {
          background: ${theme.rgba "bg_popup" style.popupAlpha};
          border: ${hairline};
          border-radius: ${px [ style.cornerRadius ]};
        }

        tooltip label {
          color: ${theme.color "fg_0"};
          padding: ${
            px [
              style.smallSpacing
              style.spacing
            ]
          };
        }
      '';
    };
  };
}
