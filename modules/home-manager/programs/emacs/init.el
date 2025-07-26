(require 'package)
(package-initialize)

(require 'smart-mode-line)
(require 'markdown-mode)
(require 'monokai-pro-theme)
(require 'direnv)
(require 'beacon)

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

(set-frame-font "Source Code Pro:size=12")
(load-theme 'monokai-pro t)
(add-hook 'find-file-hook (lambda () (display-line-numbers-mode 1))) ; Line Nr
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
(beacon-mode)
(direnv-mode)

(require 'org)

(defun load-conf-file (file)
  (interactive "f")
  (load-file (concat (concat (getenv "HOME") "/.emacs.d/") file)))

;; (load-conf-file "org.el")

;; Backup-diretory and Server
(setf backup-directory-alist '((".*" . "~/.saves/")))
