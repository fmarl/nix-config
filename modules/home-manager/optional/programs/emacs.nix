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
          kind-icon
          svg-lib
          dap-mode
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
          eat

          # Org
          org-modern

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
          rust-mode

          # Mail & IRC
          
        ];
    };
  };
}
