(require 'package)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t
      use-package-expand-minimally t
      use-package-compute-statistics t
      custom-safe-themes t)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      inhibit-startup-screen t
      native-comp-async-report-warnings-errors nil)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(global-prettify-symbols-mode 1)
(set-frame-font "Source Code Pro:size=14")
(set-cursor-color "#ffffff")
(setq ring-bell-function 'ignore)

;; Backup und Auto-Save
(setq backup-directory-alist '((".*" . "~/.saves/"))
      auto-save-default nil)

;; Theme
(use-package zenburn-theme
  :config (load-theme 'zenburn t))

;; Mode Line
(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup))
(use-package smart-mode-line-powerline-theme
  :after smart-mode-line
  :config (sml/apply-theme 'powerline))

;; Which-key (Shortcut-Hilfe)
(use-package which-key :config (which-key-mode))

;; Projectile (Projektmanagement)
(use-package projectile
  :init (projectile-mode +1)
  :bind-keymap ("C-c p" . projectile-command-map))

;; Treemacs (Projekt-Explorer)
(use-package treemacs
  :defer t
  :bind (("M-0" . treemacs-select-window)
         ("C-x t t" . treemacs)
         ("C-x t C-t" . treemacs-find-file))
  :config
  (setq treemacs-width 30
        treemacs-follow-after-init t
        treemacs-show-hidden-files t)
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1))
(use-package treemacs-projectile :after (treemacs projectile))

;; Ace / Jump Navigation
(use-package ace-window :bind (("M-p" . ace-window)))
(use-package ace-jump-mode :bind (("C-c SPC" . ace-jump-mode)))

;; Smex (M-x)
(use-package smex
  :init (smex-initialize)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)))

;; Markdown
(use-package markdown-mode :mode "\\.md\\'")

;; Direnv
(use-package direnv
  :config (direnv-mode))

(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command) ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer) ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame) ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)	;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)		;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer) ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store) ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop) ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake) ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)	 ;; orig. goto-line
         ("M-g M-g" . consult-goto-line) ;; orig. goto-line
         ("M-g o" . consult-outline) ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-f d" . consult-find) ;; Alternative: consult-fd
         ("M-f c" . consult-locate)
         ("M-f g" . consult-grep)
         ("M-f G" . consult-git-grep)
         ("M-f r" . consult-ripgrep)
         ("M-f l" . consult-line)
         ("M-f L" . consult-line-multi)
         ("M-f k" . consult-keep-lines)
         ("M-f u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history) ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history) ;; orig. isearch-edit-string
         ("M-s l" . consult-line) ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)	;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history) ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init

  (define-prefix-command 'my/search-map)
  (global-set-key (kbd "M-f") 'my/search-map)
  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<") ;; "C-+"
  (setq consult-ripgrep-command
	"rg --null --line-buffered --color=never --max-columns=1000 --path-separator --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob '!.git/*' --glob '!.direnv/*'")
  )

(use-package marginalia
  :init (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles orderless)))))

(use-package vertico
  :init (vertico-mode))

(defun load-conf-file (file)
  (interactive "f")
  (load-file (concat (concat (getenv "HOME") "/.emacs.d/") file)))

(load-conf-file "completion.el")
(load-conf-file "lsp.el")
(load-conf-file "rust.el")
(load-conf-file "scheme.el")
(load-conf-file "zig.el")
(load-conf-file "magit.el")
(load-conf-file "cc.el")
(load-conf-file "nix.el")

(provide 'init)
