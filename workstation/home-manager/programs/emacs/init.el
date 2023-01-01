(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(package-selected-packages
   '(neotree ace-popup-menu tuareg haskell-snippets haskell-mode rust-mode ivy posframe projectile acm-terminal idris-mode utop merlin slime-company slime geiser-chez geiser smart-mode-line-powerline-theme yaml-mode dracula-theme exotica-theme ormolu which-key dante dap-mode flycheck-haskell nix-mode google-c-style flycheck-clang-tidy one-themes clang-format+ ag powerline lua-mode ssh-deploy php-mode smex ranger exwm pinentry magit treemacs-all-the-icons yasnippet use-package rustic rtags nasm-mode multi-term monokai-pro-theme flycheck-rust flycheck-irony dashboard company-irony-c-headers company-irony cmake-project cmake-mode cmake-ide clang-format cargo))
 '(warning-suppress-log-types '((use-package)))
 '(warning-suppress-types '((use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(require 'package)
(package-initialize)

(require 'org)
(use-package smart-mode-line)
(use-package smart-mode-line-powerline-theme
  :after smart-mode-line
  :config
  (sml/setup)
  (sml/apply-theme 'powerline))
(use-package smex
  :init (smex-initialize)
  :bind
  (:map global-map
	("M-x" . 'smex)
	("M-X" . 'smex-major-mode-commands)))
(use-package markdown-mode)
(use-package monokai-pro-theme)
(use-package ace-window
  :bind
  (:map global-map
	("M-p" . 'ace-window)))
(use-package ace-jump-mode
  :bind
  (:map global-map
	("C-c SPC" . 'ace-jump-mode)))
(use-package dashboard
  :init (dashboard-setup-startup-hook))
(use-package direnv
  :config
  (direnv-mode))
(use-package beacon
  :config
  (beacon-mode))
;; =================================================================================

;;=============
;; GUI settings
;;=============
(set-frame-font "Source Code Pro:size=12")
(load-theme 'monokai-pro t)
(add-hook 'find-file-hook (lambda () (linum-mode 1))) ; Line Nr
(column-number-mode 1)
(tool-bar-mode -1)                                    ; Disable Toolbar
(menu-bar-mode -1)                                    ; Disable Menubar
(scroll-bar-mode -1)                                  ; Disable Scrollbar
(show-paren-mode 1)                                   ; Show parens
(electric-pair-mode 1)
(set-cursor-color "#ffffff")
(global-prettify-symbols-mode +1)
(ido-mode t)
(winner-mode 1)
;; =================================================================================

(defun load-conf-file (file)
  (interactive "f")
  (load-file (concat (concat (getenv "HOME") "/.emacs.d/") file)))

(load-conf-file "ide.el")
(load-conf-file "rust.el")
(load-conf-file "haskell.el")
(load-conf-file "scheme.el")
(load-conf-file "lisp.el")
;; (load-conf-file "ocaml.el")
;; (load-conf-file "ats2.el")
;; (load-conf-file "idris.el")
(load-conf-file "mu4e.el")
(load-conf-file "nasm.el")
(load-conf-file "cc.el")

;; Backup-diretory and Server
(setf backup-directory-alist '((".*" . "~/.saves/")))
(server-start)
