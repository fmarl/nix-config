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
      package = pkgs.emacs-pgtk;
      
      extraPackages =
        epkgs: with epkgs; [
          # Core
          use-package
          zenburn-theme
          moody
          smex
          ace-window
          avy
          direnv
          posframe
          magit
          projectile
          yasnippet
          yasnippet-snippets
          markdown-mode
          paredit
          rainbow-delimiters
          marginalia
          orderless
          consult
          vertico
          dirvish
          
          # LSP
          consult-eglot
          cape
          corfu

          # Nix Mode
          nix-mode

          # C
          clang-format

          # Rust
          rustic

          # OCaml
          tuareg
          dune
          utop

          # Clojure
          cider
          
          # Mail & IRC
          circe
        ];
    };
  };
}
