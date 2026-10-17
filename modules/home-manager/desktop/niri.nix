{
  config,
  lib,
  pkgs,
  theme,
  bemenu,
  ...
}:
let
  inherit (theme) style;

  osd = import ../lib/osd.nix { inherit pkgs; };

  wallpaper = pkgs.writeShellScript "wallpaper" ''
    image="$HOME/Pictures/wallpaper.jpg"
    if [ -f "$image" ]; then
        exec ${pkgs.swaybg}/bin/swaybg --mode fill --image "$image"
    fi
    exec ${pkgs.swaybg}/bin/swaybg --color ${theme.color "bg_0"}
  '';

  locked = command: {
    _props.allow-when-locked = true;
    spawn = command;
  };

  # Bind action without arguments, e.g. Mod+H { focus-column-left; }
  action = name: { ${name} = { }; };

  workspaceBinds = lib.listToAttrs (
    lib.concatMap (i: [
      (lib.nameValuePair "Mod+${toString i}" { focus-workspace = i; })
      (lib.nameValuePair "Mod+Ctrl+${toString i}" { move-column-to-workspace = i; })
    ]) (lib.range 1 9)
  );
in
{
  config = lib.mkIf config.machine.desktop {
    wayland.windowManager.niri = {
      enable = true;

      # The NixOS module installs niri's systemd units and portals
      systemd.enable = false;
      portalPackage = null;

      settings = {
        prefer-no-csd = { };

        hotkey-overlay.skip-at-startup = { };

        cursor = {
          xcursor-theme = style.cursorTheme;
          xcursor-size = style.cursorSize;
        };

        input = {
          keyboard.xkb = {
            layout = "us";
            variant = "altgr-intl";
          };

          touchpad = {
            tap = { };
            click-method = "button-areas";
          };

          trackpoint.off = { };

          # Kensington SlimBlade: twisting the ball sends wheel events itself
          trackball.accel-profile = "adaptive";

          tablet.off = { };
          touch.off = { };

          mod-key = "Super";
          mod-key-nested = "Alt";
        };

        layout = {
          gaps = style.largeSpacing;
          # The wallpaper shows through
          background-color = "transparent";
          center-focused-column = "never";

          preset-column-widths._children = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

          default-column-width.proportion = 0.5;

          focus-ring = {
            width = 2;
            active-color = theme.color "br_blue";
            inactive-color = theme.hairline;
          };

          border.off = { };

          shadow = {
            softness = 30;
            spread = 5;
            offset._props = {
              x = 0;
              y = 5;
            };
            color = if theme.dark then "#000b" else "#0007";
          };
        };

        overview.backdrop-color = theme.color "bg_2";

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        # Repeated nodes, other modules append to this list
        _children = [
          { spawn-at-startup = [ "${wallpaper}" ]; }
          {
            layer-rule._children = [
              { match._props.namespace = "^wallpaper$"; }
              { place-within-backdrop = true; }
            ];
          }
        ];

        binds = {
          "Mod+Shift+Slash" = action "show-hotkey-overlay";

          "Mod+P" = {
            _props.hotkey-overlay-title = "Run bemenu";
            spawn = [ "${bemenu.run}" ];
          };

          "XF86AudioRaiseVolume" = locked [
            "${osd.volume}"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.1+"
          ];
          "XF86AudioLowerVolume" = locked [
            "${osd.volume}"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.1-"
          ];
          "XF86AudioMute" = locked [
            "${osd.volume}"
            "set-mute"
            "@DEFAULT_AUDIO_SINK@"
            "toggle"
          ];
          "XF86AudioMicMute" = locked [
            "${osd.volume}"
            "set-mute"
            "@DEFAULT_AUDIO_SOURCE@"
            "toggle"
          ];
          "XF86MonBrightnessUp" = locked [
            "${osd.brightness}"
            "+10%"
          ];
          "XF86MonBrightnessDown" = locked [
            "${osd.brightness}"
            "10%-"
          ];

          "Mod+O" = action "toggle-overview" // {
            _props.repeat = false;
          };
          "Mod+Shift+C" = action "close-window" // {
            _props.repeat = false;
          };

          "Mod+Left" = action "focus-column-left";
          "Mod+Down" = action "focus-window-down";
          "Mod+Up" = action "focus-window-up";
          "Mod+Right" = action "focus-column-right";
          "Mod+H" = action "focus-column-left";
          "Mod+J" = action "focus-window-down";
          "Mod+K" = action "focus-window-up";
          "Mod+L" = action "focus-column-right";

          "Mod+Ctrl+Left" = action "move-column-left";
          "Mod+Ctrl+Down" = action "move-window-down";
          "Mod+Ctrl+Up" = action "move-window-up";
          "Mod+Ctrl+Right" = action "move-column-right";
          "Mod+Ctrl+H" = action "move-column-left";
          "Mod+Ctrl+J" = action "move-window-down";
          "Mod+Ctrl+K" = action "move-window-up";
          "Mod+Ctrl+L" = action "move-column-right";

          "Mod+Home" = action "focus-column-first";
          "Mod+End" = action "focus-column-last";
          "Mod+Ctrl+Home" = action "move-column-to-first";
          "Mod+Ctrl+End" = action "move-column-to-last";

          "Mod+Shift+Left" = action "focus-monitor-left";
          "Mod+Shift+Down" = action "focus-monitor-down";
          "Mod+Shift+Up" = action "focus-monitor-up";
          "Mod+Shift+Right" = action "focus-monitor-right";
          "Mod+Shift+H" = action "focus-monitor-left";
          "Mod+Shift+J" = action "focus-monitor-down";
          "Mod+Shift+K" = action "focus-monitor-up";
          "Mod+Shift+L" = action "focus-monitor-right";

          "Mod+Shift+Ctrl+Left" = action "move-column-to-monitor-left";
          "Mod+Shift+Ctrl+Down" = action "move-column-to-monitor-down";
          "Mod+Shift+Ctrl+Up" = action "move-column-to-monitor-up";
          "Mod+Shift+Ctrl+Right" = action "move-column-to-monitor-right";
          "Mod+Shift+Ctrl+H" = action "move-column-to-monitor-left";
          "Mod+Shift+Ctrl+J" = action "move-column-to-monitor-down";
          "Mod+Shift+Ctrl+K" = action "move-column-to-monitor-up";
          "Mod+Shift+Ctrl+L" = action "move-column-to-monitor-right";

          "Mod+Page_Down" = action "focus-workspace-down";
          "Mod+Page_Up" = action "focus-workspace-up";
          "Mod+U" = action "focus-workspace-down";
          "Mod+I" = action "focus-workspace-up";
          "Mod+Ctrl+Page_Down" = action "move-column-to-workspace-down";
          "Mod+Ctrl+Page_Up" = action "move-column-to-workspace-up";
          "Mod+Ctrl+U" = action "move-column-to-workspace-down";
          "Mod+Ctrl+I" = action "move-column-to-workspace-up";

          "Mod+Shift+Page_Down" = action "move-workspace-down";
          "Mod+Shift+Page_Up" = action "move-workspace-up";
          "Mod+Shift+U" = action "move-workspace-down";
          "Mod+Shift+I" = action "move-workspace-up";

          "Mod+WheelScrollDown" = action "focus-workspace-down" // {
            _props.cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = action "focus-workspace-up" // {
            _props.cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollDown" = action "move-column-to-workspace-down" // {
            _props.cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollUp" = action "move-column-to-workspace-up" // {
            _props.cooldown-ms = 150;
          };

          "Mod+WheelScrollRight" = action "focus-column-right";
          "Mod+WheelScrollLeft" = action "focus-column-left";
          "Mod+Ctrl+WheelScrollRight" = action "move-column-right";
          "Mod+Ctrl+WheelScrollLeft" = action "move-column-left";

          "Mod+Shift+WheelScrollDown" = action "focus-column-right";
          "Mod+Shift+WheelScrollUp" = action "focus-column-left";
          "Mod+Ctrl+Shift+WheelScrollDown" = action "move-column-right";
          "Mod+Ctrl+Shift+WheelScrollUp" = action "move-column-left";

          "Mod+BracketLeft" = action "consume-or-expel-window-left";
          "Mod+BracketRight" = action "consume-or-expel-window-right";
          "Mod+Comma" = action "consume-window-into-column";
          "Mod+Period" = action "expel-window-from-column";

          "Mod+R" = action "switch-preset-column-width";
          "Mod+Shift+R" = action "switch-preset-window-height";
          "Mod+Ctrl+R" = action "reset-window-height";
          "Mod+F" = action "maximize-column";
          "Mod+Shift+F" = action "fullscreen-window";
          "Mod+Ctrl+F" = action "expand-column-to-available-width";
          "Mod+C" = action "center-column";
          "Mod+Ctrl+C" = action "center-visible-columns";

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+V" = action "toggle-window-floating";
          "Mod+Shift+V" = action "switch-focus-between-floating-and-tiling";
          "Mod+W" = action "toggle-column-tabbed-display";

          "Print" = action "screenshot";
          "Ctrl+Print" = action "screenshot-screen";
          "Alt+Print" = action "screenshot-window";

          "Mod+Escape" = action "toggle-keyboard-shortcuts-inhibit" // {
            _props.allow-inhibiting = false;
          };

          "Mod+Shift+E" = action "quit";
          "Ctrl+Alt+Delete" = action "quit";
          "Mod+Shift+P" = action "power-off-monitors";
        }
        // workspaceBinds;
      };
    };
  };
}
