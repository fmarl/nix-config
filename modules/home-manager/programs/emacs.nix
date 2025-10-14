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
    # home.file = {
    #   ".emacs.d" = {
    #     source = ./emacs;
    #     recursive = true;
    #   };
    # };

    services.emacs.enable = true;
    programs.emacs = {
      enable = true;

      extraPackages =
        epkgs: with epkgs; [
          # Core
          use-package
          zenburn-theme
          smart-mode-line
          smart-mode-line-powerline-theme
          smex
          ace-window
          ace-jump-mode
          direnv
          posframe
          magit
          projectile
          treemacs
          treemacs-projectile
          dap-mode
          yasnippet
          yasnippet-snippets
          markdown-mode
          paredit
          rainbow-delimiters
          marginalia
          orderless
          embark
          embark-consult
          consult
          vertico

          # LSP
          lsp-mode
          lsp-ui
          lsp-ivy
          kind-icon
          cape
          corfu

          # Nix Mode
          nix-mode

          # C
          clang-format

          # Zig
          zig-mode

          # Rust
          rustic
          rust-mode

          # Scheme
          geiser
        ];
    };

  };
}
