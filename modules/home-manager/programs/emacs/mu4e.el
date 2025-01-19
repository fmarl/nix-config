(require 'mu4e)

;; ---------------------------------------------
;; General conf settings
;; ---------------------------------------------

;; Set keybind to enter mu4
(global-set-key (kbd "C-x t") 'mu4e)

(setq mu4e-user-mail-address-list '("f.m.liestmann@fx-ttr.de"))

;; viewing options
(setq mu4e-view-show-addresses t)
;; Do not leave message open after it has been sent
(setq message-kill-buffer-on-exit t)
;; Don't ask for a 'context' upon opening mu4e
(setq mu4e-context-policy 'pick-first)
;; Don't ask to quit
(setq mu4e-confirm-quit nil)

(setq mu4e-maildir-shortcuts
      '(("/ionos/Inbox" . ?i)
	))

;; attachments go here
(setq mu4e-attachment-dir  "~/Downloads/MailAttachments")

;; modify behavior when putting something in the trash (T flag) so as
;; to make it sync to the remote server. This code deals with the bug
;; that, whenever a message is marked with the trash label T,
;; offlineimap wont sync it back to the gmail servers.
;;
;; NOTE: Taken from
;; http://cachestocaches.com/2017/3/complete-guide-email-emacs-using-mu-and-/
(defun remove-nth-element (nth list)
  (if (zerop nth) (cdr list)
    (let ((last (nthcdr (1- nth) list)))
      (setcdr last (cddr last))
      list)))

(setq mu4e-marks (remove-nth-element 5 mu4e-marks))

(setf (alist-get 'trash mu4e-marks)
      (list :char '("d" . "▼")
            :prompt "dtrash"
            :dyn-target (lambda (target msg)
                          (mu4e-get-trash-folder msg))
            :action (lambda (docid msg target)
                      ;; Here's the main difference to the regular trash mark,
                      ;; no +T before -N so the message is not marked as
                      ;; IMAP-deleted:
                      (mu4e--server-move docid (mu4e--mark-check-target target) "-N"))))

;; ---------------------------------------------
;; Contexts conf settings
;; ---------------------------------------------
(setq mu4e-contexts
      `(
	,(make-mu4e-context
	  :name "IONOS Account"
	  :match-func (lambda (msg) (when msg
				 (string-prefix-p "/ionos" (mu4e-message-field msg :maildir))))
	  :vars '(
		  (mu4e-trash-folder . "/ionos/Papierkorb")
		  (mu4e-refile-folder . "/ionos/Archiv")
		  (mu4e-drafts-folder . "/ionos/Entwürfe")
		  (mu4e-sent-folder . "/ionos/Gesendete Objekte")
		  (user-mail-address . "f.m.liestmann@fx-ttr.de")
		  ))
	)
      )

;; Set how email is to be sent
(setq sendmail-program "msmt"
      send-mail-function 'smtpmail-send-it
      message-sendmail-f-is-evil t
      message-sendmail-extra-arguments '("--read-envelope-from")
      message-send-mail-function 'message-send-mail-with-sendmail)
