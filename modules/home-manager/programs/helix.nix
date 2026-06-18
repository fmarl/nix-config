{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.helix;
in
{
  options.modules.helix.enable = lib.mkEnableOption "Install and configure helix";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;

      settings = {
        theme = "autumn";

        editor = {
          bufferline = "multiple";
          cursorline = true;
          rulers = [ 120 ];
          true-color = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          lsp = {
            auto-signature-help = false;
            display-messages = true;
          };

          statusline = {
            left = [
              "mode"
              "spinner"
              "version-control"
              "file-name"
            ];
          };

          end-of-line-diagnostics = "hint";

          inline-diagnostics = {
            cursor-line = "error";
            other-lines = "disable";
          };
        };
      };
    };
  };
}
