(use-package haskell-mode
  :after (direnv)
  :hook ((haskell-mode . my-haskell-hook)
	 (haskell-mode . interactive-haskell-mode))

  :config
  (defcustom haskell-formatter 'ormolu
    "The Haskell formatter to use. One of: 'ormolu, 'stylish, nil. Set it per-project in .dir-locals."
    :safe 'symbolp)

  (defun my-haskell-hook () (eldoc-mode nil))

  (defun haskell-smart-format ()
    "Format a buffer based on the value of 'haskell-formatter'."
    (interactive)
    (cl-ecase haskell-formatter
      ('ormolu (ormolu-format-buffer))
      ('stylish (haskell-mode-stylish-buffer))
      (nil nil)
      ))

  (defun haskell-switch-formatters ()
    "Switch from ormolu to stylish-haskell, or vice versa."
    (interactive)
    (setq haskell-formatter
          (cl-ecase haskell-formatter
            ('ormolu 'stylish)
            ('stylish 'ormolu)
            (nil nil))))

  ;; haskell-mode doesn't know about newer GHC features.
  (let ((new-extensions '("QuantifiedConstraints"
                          "DerivingVia"
                          "BlockArguments"
                          "DerivingStrategies"
                          "StandaloneKindSignatures"
                          "ImportQualifiedPost"
                          )))
    (setq
     haskell-ghc-supported-extensions
     (append haskell-ghc-supported-extensions new-extensions)))

  :bind (:map haskell-mode-map
         ("C-c a c" . haskell-cabal-visit-file)
         ("C-c a i" . haskell-navigate-imports)
         ("C-c M"   . haskell-compile)
         ("C-c a I" . haskell-navigate-imports-return)))

(use-package haskell-snippets
  :defer t
  :after (haskell-mode yasnippet)
  )
(use-package ormolu)
