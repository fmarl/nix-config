(use-package geiser
  :ensure t
  :init
  (setq geiser-chez-binary "scheme")
  (setq geiser-active-implementations '(chez)))
