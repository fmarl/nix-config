(use-package slime
  :config      
  (slime-setup '(slime-fancy slime-company))
  :init
  (setq inferior-lisp-program "sbcl"))

(use-package slime-company
  :after slime
  :bind-keymap 
    ("C-n" . company-select-next)
    ("C-p" . company-select-previous)
    ("C-d" . company-show-doc-buffer)
    ("M-." . company-show-location)
  :config (setq slime-company-completion 'fuzzy
                slime-company-after-completion 'slime-company-just-one-space))
