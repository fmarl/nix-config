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
    # The config is provided via dotfiles.
    services.emacs.enable = true;
    programs.emacs = {
      enable = true;

      extraPackages =
        epkgs: with epkgs; [
          # Core
          ef-themes
          ace-window
          avy
          envrc
          posframe
          magit
          dirvish
          eldoc-box
          consult-eglot
          corfu
          cape
          yasnippet
          yasnippet-snippets
          paredit
          rainbow-delimiters
          embark
          embark-consult
          wgrep
          diff-hl
          consult
          marginalia
          orderless
          vertico
          markdown-mode
          terraform-mode
          yaml-mode
          apheleia
          circe
          elfeed
          meow

          # Org & Denote
          denote

          # Go
          go-dlv
          gotest

          # Java
          eglot-java

          # Nix
          nix-ts-mode

          # OCaml
          tuareg
          dune
          utop

          # Lisp
          sly

          # Clojure
          cider

          # Treesitter
          (treesit-grammars.with-grammars (grammars: [
            grammars.tree-sitter-rust
            grammars.tree-sitter-python
            grammars.tree-sitter-nix
            grammars.tree-sitter-ocaml
            grammars.tree-sitter-clojure
            grammars.tree-sitter-go
            grammars.tree-sitter-bash
          ]))
        ];
    };
  };
}
