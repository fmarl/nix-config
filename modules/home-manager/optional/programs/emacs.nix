{
  jail,
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
    services.emacs.enable = true;
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      
      extraPackages =
        epkgs: with epkgs; [
          # Core
          use-package
          ef-themes
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
          nix-ts-mode

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

          # Gleam
          gleam-ts-mode
          
          # Mail & IRC
          circe

	  # Treesitter
	  tree-sitter-langs
	  (treesit-grammars.with-grammars (grammars: [
	    grammars.tree-sitter-rust
	    grammars.tree-sitter-ocaml
	    grammars.tree-sitter-nix
	    grammars.tree-sitter-gleam
	  ]))
        ];
    };
  };
}
