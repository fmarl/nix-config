{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.labwc;
in
{
  options.modules.labwc.enable = lib.mkEnableOption "Install and configure labwc";

  config = lib.mkIf cfg.enable {
    modules.wayland = {
      enable = true;
      lightdm = true;
    };

    programs = {
      labwc.enable = true;
    };
  };
}
