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
    # The config is provided via dotfiles.
    services.emacs.enable = true;
    programs.emacs = {
      enable = true;

      extraPackages = epkgs: with epkgs; [
        # Core
        use-package
        ef-themes
        moody
        smex
        ace-window
        avy
        direnv
        posframe
        magit
        projectile
        dirvish
	eldoc-box
	consult-eglot
        corfu
        cape
        yasnippet
        yasnippet-snippets
        paredit
        rainbow-delimiters
	consult
	marginalia
	orderless
	vertico
	      vterm
	      multi-vterm
	      markdown-mode
	      terraform-mode
	      yaml-mode

	# C / C++
	clang-format
	
        # Python
        blacken
        python-mode

        # Go
        go-mode
        go-eldoc
        go-dlv
        gotest

	      # Java
	      eglot-java

	      # Nix
	      nix-ts-mode

        # Rust
        rustic

        # OCaml
        tuareg
        dune
        utop

        # Clojure
        cider
        
        elfeed
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
