{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.librewolf;

  amo = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  ublock = "uBlock0@raymondhill.net";
  bitwarden = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
  toolbarId =
    id: "${lib.toLower (lib.replaceStrings [ "@" "." "{" "}" ] [ "_" "_" "_" "_" ] id)}-browser-action";
in
{
  options.modules.librewolf.enable = lib.mkEnableOption "Install and configure librewolf";

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;

      policies.ExtensionSettings = {
        ${ublock} = {
          installation_mode = "force_installed";
          install_url = amo "ublock-origin";
        };
        ${bitwarden} = {
          installation_mode = "force_installed";
          install_url = amo "bitwarden-password-manager";
        };
      };

      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [ ];
            unified-extensions-area = [ ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "downloads-button"
              "fxa-toolbar-menu-button"
              "unified-extensions-button"
              (toolbarId bitwarden)
              (toolbarId ublock)
            ];
            toolbar-menubar = [ "menubar-items" ];
            TabsToolbar = [
              "firefox-view-button"
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            vertical-tabs = [ ];
            PersonalToolbar = [
              "import-button"
              "personal-bookmarks"
            ];
          };
          seen = [
            "developer-button"
            (toolbarId ublock)
            (toolbarId bitwarden)
          ];
          dirtyAreaCache = [
            "nav-bar"
            "vertical-tabs"
            "PersonalToolbar"
            "toolbar-menubar"
            "TabsToolbar"
          ];
          currentVersion = 20;
          newElementCount = 3;
        };
      };
    };
  };
}
