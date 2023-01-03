{ pkgs, ... }: {
  programs.emacs = {
    enable = true;

    extraPackages = (epkgs:
      (with pkgs; [
        pkgs.mu
      ]) ++
      (with epkgs.melpaPackages; [
    	  monokai-pro-theme
		    clang-format
		    google-c-style
		    ormolu
      ]) ++
      (with epkgs.melpaStablePackages; [
    		use-package
		    smart-mode-line
		    smart-mode-line-powerline-theme
		    smex
		    dashboard
		    markdown-mode
		    ace-window
		    yasnippet
		    direnv
		    beacon
		    cmake-mode
		    haskell-mode
		    haskell-snippets
		    projectile
		    ivy
		    posframe
		    neotree
		    idris-mode
		    slime
		    slime-company
		    nasm-mode
		    tuareg
		    merlin
		    utop
		    rust-mode
		    rustic
		    flycheck-rust
		    cargo
		    geiser
      ]));
  };
}
