{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.emacs;
in
{
  options.modules.emacs.enable = lib.mkEnableOption "Install and configure emacs";

  config = lib.mkIf cfg.enable {
    services.emacs.enable = true;
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;

      extraPackages =
        epkgs: with epkgs; [
          # Core
          ef-themes
          ace-window
          avy
          envrc
          magit
          dirvish
          wgrep
          diff-hl
          apheleia
          meow
          paredit

          vertico
          orderless
          marginalia
          consult
          embark
          embark-consult
          corfu
          cape
          yasnippet
          yasnippet-snippets

          # LSP
          consult-eglot
          eglot-java

          org-modern
          denote

          circe
          elfeed
          mu4e

          markdown-mode
          terraform-mode
          yaml-mode
          nix-ts-mode
          cider
          tuareg
          dune
          utop
          haskell-mode
          zig-mode
          gleam-ts-mode
          nasm-mode

          # Treesitter
          (treesit-grammars.with-grammars (grammars: [
            grammars.tree-sitter-bash
            grammars.tree-sitter-rust
            grammars.tree-sitter-nix
            grammars.tree-sitter-ocaml
            grammars.tree-sitter-clojure
          ]))
        ];
    };
  };
}
