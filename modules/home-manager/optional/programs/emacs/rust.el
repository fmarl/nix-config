(use-package rustic
  :defer t
  :config
  (setq rustic-format-on-save t)
  (setq rustic-lsp-client 'eglot)
  )

(with-eval-after-load 'rustic
  (define-key rustic-mode-map (kbd "C-c C-c c") #'rustic-cargo-check)
  (define-key rustic-mode-map (kbd "C-c C-c r") #'rustic-cargo-run))
