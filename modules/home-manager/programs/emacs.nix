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

      extraPackages = epkgs: with epkgs; [
        # Core
        use-package
        ef-themes
        moody
        smex
        ace-window
        avy
        envrc
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
	embark
	embark-consult
	wgrep
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

        # Org & Denote
        denote

        # C / C++
        clang-format

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

        # Zig
        zig-mode

        # Clojure
        cider

        # Meow-edit
        meow

        # Treesitter
        tree-sitter-langs
        (treesit-grammars.with-grammars (grammars: [
          grammars.tree-sitter-rust
	  grammars.tree-sitter-python
          grammars.tree-sitter-nix
          grammars.tree-sitter-ocaml
          grammars.tree-sitter-clojure
          grammars.tree-sitter-zig
        ]))
      ];
    };
  };
}
