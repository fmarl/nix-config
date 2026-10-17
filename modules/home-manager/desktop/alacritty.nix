{
  config,
  lib,
  theme,
  ...
}:
let
  inherit (theme) style;
  font = style: {
    family = theme.style.monospaceFont;
    inherit style;
  };

  # Programs expect black to be dark and white to be light
  ansi =
    if theme.dark then
      {
        black = "bg_1";
        white = "fg_1";
        brightBlack = "dim_0";
        brightWhite = "fg_0";
      }
    else
      {
        black = "fg_0";
        white = "bg_active";
        brightBlack = "dim_0";
        brightWhite = "bg_1";
      };
in
{
  config = lib.mkIf config.machine.desktop {
    wayland.windowManager.niri.settings.binds."Mod+Shift+Return" = {
      _props.hotkey-overlay-title = "Open alacritty";
      spawn = [ (lib.getExe config.programs.alacritty.package) ];
    };

    programs.alacritty = {
      enable = true;

      settings = {
        font = {
          size = 12;
          offset = {
            x = 0;
            y = 2;
          };
          normal = font "Regular";
          bold = font "Bold";
          italic = font "Italic";
          bold_italic = font "Bold Italic";
        };

        window = {
          dynamic_padding = true;
          padding = {
            x = style.largeSpacing;
            y = style.largeSpacing;
          };
        };

        mouse.hide_when_typing = true;

        selection.save_to_clipboard = true;

        colors = {
          primary = {
            background = theme.color "bg_0";
            foreground = theme.color "fg_0";
          };
          cursor = {
            cursor = theme.color "cursor";
            text = theme.color "bg_0";
          };
          selection = {
            background = theme.color "bg_region";
            text = theme.color "fg_0";
          };
          normal = {
            black = theme.color ansi.black;
            red = theme.color "red";
            green = theme.color "green";
            yellow = theme.color "yellow";
            blue = theme.color "blue";
            magenta = theme.color "magenta";
            cyan = theme.color "cyan";
            white = theme.color ansi.white;
          };
          bright = {
            black = theme.color ansi.brightBlack;
            red = theme.color "br_red";
            green = theme.color "br_green";
            yellow = theme.color "br_yellow";
            blue = theme.color "br_blue";
            magenta = theme.color "br_magenta";
            cyan = theme.color "br_cyan";
            white = theme.color ansi.brightWhite;
          };
        };
      };
    };
  };
}
