{ self, config, lib, pkgs, inputs, ... }:

with lib;

let cfg = config.modules.librewolf;
in {
  options.modules.librewolf.enable =
    mkEnableOption "Install and configure librewolf";

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.uiCustomization.state" = ''
          {
                      "placements": {
                        "widget-overflow-fixed-list":[],
                        "unified-extensions-area":[],
                        "nav-bar": [
                          "back-button",
                          "forward-button",
                          "stop-reload-button",
                          "urlbar-container",
                          "save-to-pocket-button",
                          "downloads-button",
                          "fxa-toolbar-menu-button",
                          "unified-extensions-button",
                          "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action",
                          "ublock0_raymondhill_net-browser-action"
                        ],
                        "toolbar-menubar": [
                          "menubar-items"
                        ],
                        "TabsToolbar": [
                          "firefox-view-button",
                          "tabbrowser-tabs",
                          "new-tab-button",
                          "alltabs-button"
                        ],
                        "vertical-tabs": [],
                        "PersonalToolbar": [
                          "import-button",
                          "personal-bookmarks"
                        ]
                      },
                      "seen": [
                        "developer-button",
                        "ublock0_raymondhill_net-browser-action",
                        "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                      ],
                      "dirtyAreaCache": [
                        "nav-bar",
                        "vertical-tabs",
                        "PersonalToolbar",
                        "toolbar-menubar",
                        "TabsToolbar"
                      ],
                      "currentVersion": 20,
                      "newElementCount": 3
                    }'';
      };
    };
  };
}
