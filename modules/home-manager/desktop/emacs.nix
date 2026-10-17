{
  config,
  lib,
  pkgs,
  ...
}:
let
  emacsclient = "${config.programs.emacs.finalPackage}/bin/emacsclient";
in
{
  config = lib.mkIf config.machine.desktop {
    wayland.windowManager.niri.settings.binds = {
      "Mod+E" = {
        _props.hotkey-overlay-title = "Open Emacs";
        spawn = [
          emacsclient
          "-c"
          "-n"
        ];
      };
      "Mod+Shift+D" = {
        _props.hotkey-overlay-title = "Start dirvish";
        spawn = [
          emacsclient
          "-c"
          "-n"
          "-e"
          "(dirvish-dwim)"
        ];
      };
    };

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
