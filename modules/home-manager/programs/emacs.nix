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

  extraPackages = epkgs: with epkgs; [
    use-package
    zenburn-theme
    smart-mode-line
    smart-mode-line-powerline-theme
    smex
    ace-window
    ace-jump-mode
    which-key
    direnv
    beacon
    posframe
    magit
    projectile
    treemacs
    treemacs-projectile
    lsp-mode
    lsp-ui
    lsp-ivy
    dap-mode
    rustic
    rust-mode
    zig-mode
    ccls
    clang-format
    corfu
    cape
    kind-icon
    yasnippet
    yasnippet-snippets
    markdown-mode
    geiser
    paredit
    rainbow-delimiters
  ];
};

  };
}
