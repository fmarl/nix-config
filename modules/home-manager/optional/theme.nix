{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.theme;
  c = (import ../colors.nix).dark;
  css = ''
    @define-color accent_color #${c.br_blue};
    @define-color accent_bg_color #${c.bg_accent};
    @define-color accent_fg_color #${c.fg_0};
    @define-color window_bg_color #${c.bg_0};
    @define-color window_fg_color #${c.fg_0};
    @define-color view_bg_color #${c.bg_0};
    @define-color view_fg_color #${c.fg_0};
    @define-color headerbar_bg_color #${c.bg_1};
    @define-color headerbar_fg_color #${c.fg_0};
    @define-color headerbar_backdrop_color #${c.bg_0};
    @define-color sidebar_bg_color #${c.bg_1};
    @define-color sidebar_fg_color #${c.fg_0};
    @define-color card_bg_color #${c.bg_1};
    @define-color card_fg_color #${c.fg_0};
    @define-color dialog_bg_color #${c.bg_1};
    @define-color dialog_fg_color #${c.fg_0};
    @define-color popover_bg_color #${c.bg_popup};
    @define-color popover_fg_color #${c.fg_0};
    @define-color destructive_color #${c.red};
    @define-color success_color #${c.green};
    @define-color warning_color #${c.yellow};
    @define-color error_color #${c.red};
  '';
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
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };

      gtk3 = {
        extraConfig.gtk-application-prefer-dark-theme = true;
        extraCss = css;
      };

      gtk4 = {
        extraConfig.gtk-application-prefer-dark-theme = true;
        extraCss = css;
      };
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
