{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.gnome;
in
{
  options.modules.gnome.enable = lib.mkEnableOption "Install and configure gnome";

  config = lib.mkIf cfg.enable {
    programs = {
      zathura.enable = true;
      mpv.enable = true;
    };
  };
}
