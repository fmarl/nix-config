(require 'mu4e)

;; ---------------------------------------------
;; General conf settings
;; ---------------------------------------------

;; Set keybind to enter mu4
(global-set-key (kbd "C-x t") 'mu4e)

(setq mu4e-user-mail-address-list '("fb@fx-ttr.de"))

;; viewing options
(setq mu4e-view-show-addresses t)
;; Do not leave message open after it has been sent
(setq message-kill-buffer-on-exit t)
;; Don't ask for a 'context' upon opening mu4e
(setq mu4e-context-policy 'pick-first)
;; Don't ask to quit
(setq mu4e-confirm-quit nil)

(setq mu4e-maildir-shortcuts
      '(("/WebAccount/INBOX" . ?w)
	("/IONOSAccount/INBOX" . ?i)
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
(add-to-list 'mu4e-marks
	     '(trash
	       :char ("d" . "▼")
	       :prompt "dtrash"
	       :dyn-target (lambda (target msg) (mu4e-get-trash-folder msg))
	       :action (lambda (docid msg target)
			 (mu4e~proc-move docid
					 (mu4e~mark-check-target target) "-N"))))


;; ---------------------------------------------
;; Contexts conf settings
;; ---------------------------------------------
(setq mu4e-contexts
      `(
	,(make-mu4e-context
	  :name "IONOS Account"
	  :match-func (lambda (msg) (when msg
				      (string-prefix-p "/IONOSAccount" (mu4e-message-field msg :maildir))))
	  :vars '(
		  (mu4e-trash-folder . "/IONOSAccount/Junk")
		  (mu4e-refile-folder . "/IONOSAccount/Archivio")
		  (mu4e-drafts-folder . "/IONOSAccount/Drafts")
		  (mu4e-sent-folder . "/IONOSAccount/Sent")
		  (user-mail-address . "florian.buestgens@efficient-dev.com")
		  (smtpmail-smtp-user . "florian.buestgens")
		  (smtpmail-local-domain . "efficient-dev.com")
		  (smtpmail-default-smtp-server . "smtp.ionos.de")
		  (smtpmail-smtp-server . "smtp.ionos.de")
		  (smtpmail-smtp-service . 587)
		  ))
	))

;; Set how email is to be sent
(setq send-mail-function (quote smtpmail-send-it))
