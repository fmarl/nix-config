{
  config,
  lib,
  pkgs,
  ...
}:


let
  cfg = config.modules.theme;

in
{
  options.modules.theme.enable = lib.mkEnableOption "Install and configure GTK themes";

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "palenight";
        package = pkgs.palenight-theme;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  };
}
