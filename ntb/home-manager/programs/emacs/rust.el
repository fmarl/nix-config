(use-package rust-mode
  :ensure t)
(use-package rustic
  :ensure t
  :config
  (setq rustic-lsp-setup-p f))
(use-package flycheck-rust
  :ensure t)

(use-package cargo
        :ensure t
        :config 
        ;; change emacs PATH o include cargo/bin
        (setenv "PATH" (concat (getenv "PATH") ":~/.cargo/bin"))
        (setq exec-path (append exec-path '("~/.cargo/bin")))
	)
