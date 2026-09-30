{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.alacritty;
  c = (import ../../colors.nix).dark;
  hex = name: "#${c.${name}}";
in
{
  options.modules.alacritty.enable = lib.mkEnableOption "Install and configure alacritty";

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        font = {
          normal.family = "Aporetic Sans Mono";
          size = 12;
        };

        window.padding = {
          x = 8;
          y = 8;
        };

        mouse.hide_when_typing = true;

        selection.save_to_clipboard = true;

        colors = {
          primary = {
            background = hex "bg_0";
            foreground = hex "fg_0";
          };
          cursor = {
            cursor = hex "cursor";
            text = hex "bg_0";
          };
          selection = {
            background = hex "bg_region";
            text = hex "fg_0";
          };
          normal = {
            black = hex "bg_1";
            red = hex "red";
            green = hex "green";
            yellow = hex "yellow";
            blue = hex "blue";
            magenta = hex "magenta";
            cyan = hex "cyan";
            white = hex "fg_0";
          };
          bright = {
            black = hex "bg_active";
            red = hex "br_red";
            green = hex "br_green";
            yellow = hex "br_yellow";
            blue = hex "br_blue";
            magenta = hex "br_magenta";
            cyan = hex "br_cyan";
            white = hex "dim_0";
          };
        };
      };
    };
  };
}
