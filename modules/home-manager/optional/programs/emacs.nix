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
          # tuareg
          # dune
          # utop

          # Clojure
          cider

          # Common Lisp
          sly
<<<<<<< HEAD
=======

	  # Scheme
	  geiser
	  geiser-guile
>>>>>>> 9b4c51e2b193625cb866d6a7e458ed20eeebe309

          # Zig
          zig-mode

          # Utils
          circe
<<<<<<< HEAD
=======
          mu4e
>>>>>>> 9b4c51e2b193625cb866d6a7e458ed20eeebe309
          elfeed

          denote
          meow

          # Treesitter
          tree-sitter-langs
          (treesit-grammars.with-grammars (grammars: [
            grammars.tree-sitter-rust
            grammars.tree-sitter-nix
            grammars.tree-sitter-zig
            grammars.tree-sitter-clojure
          ]))
        ];
    };
  };
}
