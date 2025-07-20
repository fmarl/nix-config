{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.gnome;
in
{
  options.modules.gnome.enable = mkEnableOption "Install and configure gnome";

  config = mkIf cfg.enable {
    programs = {
      alacritty.enable = true;
      zathura.enable = true;
      mpv.enable = true;
    };
  };
}
