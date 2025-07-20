{
  config,
  lib,
  pkgs,
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
        (with pkgs; [
          pkgs.mu
          pkgs.emacsPackages.mu4e
          pkgs.emacsPackages.use-package
        ])
        ++ (with epkgs.melpaPackages; [
          monokai-pro-theme
          clang-format
          google-c-style
        ])
        ++ (with epkgs.melpaStablePackages; [
          smart-mode-line
          smart-mode-line-powerline-theme
          smex
          dashboard
          markdown-mode
          ace-window
          ace-jump-mode
          yasnippet
          which-key
          direnv
          beacon
          cmake-mode
          projectile
          ivy
          posframe
          treemacs
          treemacs-projectile
          nasm-mode
          utop
          rust-mode
          rustic
          flycheck-rust
          cargo
          lsp-mode
          lsp-ui
          lsp-ivy
          magit
        ])
      );
    };
  };
}
