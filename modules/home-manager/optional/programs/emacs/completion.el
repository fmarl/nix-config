(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-quit-no-match t)
  (corfu-preview-current nil))

(use-package kind-icon
  :after corfu
  :custom (kind-icon-use-icons t)
  :config (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :after corfu
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package yasnippet
  :config (yas-global-mode 1))

(use-package yasnippet-snippets :after yasnippet)
