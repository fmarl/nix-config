(use-package rust-mode)
(use-package rustic
  :config
  (setq rustic-lsp-setup-p f))
(use-package flycheck-rust)
(use-package cargo
        :config 
        ;; change emacs PATH o include cargo/bin
        (setenv "PATH" (concat (getenv "PATH") ":~/.cargo/bin"))
        (setq exec-path (append exec-path '("~/.cargo/bin")))
	)
