{
  config,
  lib,
  theme,
  ...
}:
let
  inherit (theme) style;
in
{
  config = lib.mkIf config.machine.desktop {
    wayland.windowManager.niri.settings._children = [
      {
        layer-rule._children = [
          { match._props.namespace = "^notifications$"; }
          { block-out-from = "screencast"; }
        ];
      }
    ];

    services.mako = {
      enable = true;

      settings = {
        font = "${style.sansFont} 11";
        border-radius = style.cornerRadius;
        border-size = 1;
        padding = toString style.largeSpacing;
        margin = toString style.largeSpacing;
        background-color = theme.hexAlpha "bg_popup" style.popupAlpha;
        border-color = theme.hairline;
        text-color = theme.color "fg_0";
        progress-color = theme.color "bg_accent";

        "urgency=critical" = {
          border-size = 2;
          border-color = theme.color "red";
        };
      };
    };
  };
}
