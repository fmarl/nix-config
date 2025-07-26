{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.emacs;
in
{
  options.modules.emacs.enable = mkEnableOption "Install and configure emacs";

  config = mkIf cfg.enable {
    home.file = {
      ".emacs.d" = {
        source = ./emacs;
        recursive = true;
      };
    };

    services.emacs.enable = true;
    programs.emacs = {
      enable = true;

      extraPackages = (
        epkgs:
        [
          epkgs.use-package
        ]
        ++ (with epkgs.melpaStablePackages; [
          zenburn-theme
          smart-mode-line
          smart-mode-line-powerline-theme
          smex
          dashboard
          markdown-mode
          ace-window
          ace-jump-mode
          which-key
          direnv
          beacon
          posframe
          magit
        ])
      );
    };
  };
}
