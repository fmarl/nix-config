{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  inherit (theme) dark;
  inherit (theme) style;

  css = lib.concatStrings (
    lib.mapAttrsToList (name: color: "@define-color ${name} ${theme.color color};\n") {
      accent_color = "br_blue";
      accent_bg_color = "bg_accent";
      accent_fg_color = "fg_0";
      window_bg_color = "bg_0";
      window_fg_color = "fg_0";
      view_bg_color = "bg_0";
      view_fg_color = "fg_0";
      headerbar_bg_color = "bg_1";
      headerbar_fg_color = "fg_0";
      headerbar_backdrop_color = "bg_0";
      sidebar_bg_color = "bg_1";
      sidebar_fg_color = "fg_0";
      card_bg_color = "bg_1";
      card_fg_color = "fg_0";
      dialog_bg_color = "bg_1";
      dialog_fg_color = "fg_0";
      popover_bg_color = "bg_popup";
      popover_fg_color = "fg_0";
      destructive_color = "red";
      success_color = "green";
      warning_color = "yellow";
      error_color = "red";
    }
  );
in
{
  config = lib.mkIf config.machine.desktop {
    home.pointerCursor = {
      enable = true;
      name = style.cursorTheme;
      package = pkgs.numix-cursor-theme;
      size = style.cursorSize;
      gtk.enable = true;
    };

    gtk = {
      enable = true;

      font = {
        name = style.sansFont;
        size = 11;
      };

      iconTheme = {
        name = if dark then "Papirus-Dark" else "Papirus";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = if dark then "adw-gtk3-dark" else "adw-gtk3";
        package = pkgs.adw-gtk3;
      };

      gtk3 = {
        extraConfig.gtk-application-prefer-dark-theme = dark;
        extraCss = css;
      };

      gtk4 = {
        extraConfig.gtk-application-prefer-dark-theme = dark;
        extraCss = css;
      };
    };

    # Exposed via the XDG desktop portal (org.freedesktop.appearance), which
    # Emacs follows
    dconf.settings."org/gnome/desktop/interface".color-scheme =
      if dark then "prefer-dark" else "prefer-light";
  };
}
