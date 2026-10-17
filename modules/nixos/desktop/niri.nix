{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  tuigreetTheme = lib.concatStringsSep ";" (
    lib.mapAttrsToList (part: color: "${part}=${theme.consoleName color}") {
      container = "bg_0";
      text = "fg_0";
      greet = "fg_0";
      input = "fg_0";
      border = "br_blue";
      title = "br_blue";
      prompt = "br_blue";
      button = "br_blue";
      time = "dim_0";
      action = "dim_0";
    }
  );
in
{
  config = lib.mkIf config.machine.desktop {
    security.pam.services.waylock = { };

    services.greetd = {
      enable = true;

      settings = {
        default_session = {
          command = lib.concatStringsSep " " [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--time"
            "--remember"
            "--remember-session"
            "--asterisks"
            "--theme '${tuigreetTheme}'"
            "--sessions ${pkgs.niri}/bin/niri-session"
          ];
          user = "greeter";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    programs.niri.enable = true;
  };
}
