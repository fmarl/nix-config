{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  waylock = lib.concatStringsSep " " [
    "${pkgs.waylock}/bin/waylock"
    "-fork-on-lock"
    "-init-color 0x${theme.raw "bg_0"}"
    "-input-color 0x${theme.raw "bg_accent"}"
    "-input-alt-color 0x${theme.raw "bg_region"}"
    "-fail-color 0x${theme.raw "red"}"
  ];
  lock = "${pkgs.procps}/bin/pgrep -x waylock || ${waylock}";
in
{
  config = lib.mkIf config.machine.desktop {
    wayland.windowManager.niri.settings.binds."Super+Alt+L" = {
      _props.hotkey-overlay-title = "Lock the Screen";
      spawn-sh = lock;
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 600;
          command = lock;
        }
        {
          timeout = 900;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        }
      ];
      events = {
        before-sleep = lock;
        inherit lock;
      };
    };
  };
}
