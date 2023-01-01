(load "~/.emacs.d/ats2/ats2-mode.el")
(require 'flycheck)
(load "~/.emacs.d/ats2/flycheck-ats2.el")
(with-eval-after-load 'flycheck
   (flycheck-ats2-setup))
