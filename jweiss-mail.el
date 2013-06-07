(setq user-mail-address "jweiss@redhat.com")
(setq user-full-name "Jeff Weiss")

;; (setq gnus-posting-styles '((".*"
;;                              (signature "Jeff Weiss\nPrincipal Quality Assurance Engineer\njweiss@redhat.com\n(919)886-6533"))))

;; (setq gnus-secondary-select-methods
;;       '((nnimap "Red Hat"
;;                 (nnimap-address "mail.corp.redhat.com")
;;                 (nnimap-server-port 993)
		
;;                 (nnimap-authenticator login)
;;                 (nnimap-stream ssl)
;;                 (nnimap-expunge-on-close 'never)
;;                 (nnimap-authinfo-file
;;                  "/home/jweiss/.imap-authinfo"))))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.corp.redhat.com" 25 nil nil))
      
      smtpmail-default-smtp-server "smtp.corp.redhat.com" 
      smtpmail-smtp-server "smtp.corp.redhat.com"
      smtpmail-smtp-service 25)

(require 'bbdb)
(require 'bbdb-message)
;; We initialize BBDB for GNUS and message-mode (which is used by Gnus to compose mail)
(bbdb-initialize 'gnus 'message)

(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)

(setq bbdb-use-pop-up nil
      bbdb-notice-auto-save-file t
      bbdb-pop-up-target-lines 10
      bbdb-send-mail-style 'message)


(setq ldap-host-parameters-alist
      (quote (("ldap.corp.redhat.com" base "ou=users,dc=redhat,dc=com"))))

(require 'eudc)

(require 'gnus-art) ;; http://notmuchmail.org/pipermail/notmuch/2012/012010.html

(setq eudc-default-return-attributes nil
      eudc-strict-return-matches nil)

(setq ldap-ldapsearch-args (quote ("-tt" "-LLL" "-x")))
(eudc-protocol-set 'eudc-inline-expansion-format '("%s <%s>" cn email)
		   'ldap)
(eudc-protocol-set 'eudc-inline-query-format '((cn)
                                               (uid)
					       (mail)
                                               (sn)
                                               (givenName)
                                               (name))
		   'ldap)

(eudc-protocol-set 'eudc-inline-expansion-format '("%s %s < %s>" firstname lastname net)
		   'bbdb)
(eudc-protocol-set 'eudc-inline-query-format '((name)
					       (firstname)
					       (lastname)
					       (firstname lastname)
					       (net))
		   'bbdb)


(eudc-set-server "localhost" 'bbdb t)
(setq eudc-server-hotlist '(("localhost" . bbdb)
			    ("ldap.corp.redhat.com" . ldap)))

(setq eudc-inline-expansion-servers 'hotlist)

(defun enz-eudc-expand-inline()
  (interactive)
  (if (eq eudc-protocol 'ldap)
      (progn (move-end-of-line 1)
	     (insert "*")
	     (unless (condition-case nil
			 (eudc-expand-inline)
		       (error nil))
	       (backward-delete-char-untabify 1)))
    (eudc-expand-inline)))

;; Adds some hooks

(eval-after-load "message"
  '(define-key message-mode-map (kbd "TAB") 'enz-eudc-expand-inline))




(eval-after-load 'notmuch
  '(progn
     (require 'dbus)
     ;; to untag all new messages
     (defun notmuch-untag-all-new ()
       (interactive)
       (notmuch-search-tag-all '("-new"))
       (notmuch-search-quit))
     (define-key notmuch-search-mode-map (kbd "C-c C-k") 'notmuch-untag-all-new)

     ;; Autorefresh notmuch-hello using D-Bus
     (defun jweiss/notmuch-dbus-notify ()
       (save-excursion
	 (save-restriction
	   (when (get-buffer "*notmuch-hello*")
	     (notmuch-hello-update t)))))
     (ignore-errors
       (dbus-register-method :session dbus-service-emacs dbus-path-emacs
			     dbus-service-emacs "NotmuchNewmail"
			     'jweiss/notmuch-dbus-notify))))





;; auto check for new mail
;; (require 'gnus-demon)

;; (gnus-demon-add-handler 'gnus-demon-scan-news 10 t)

;; (setq gnus-select-group-hook 'gnus-summary-insert-new-articles)

;;  (setq-default
;;      gnus-summary-line-format "%U%R%z %(%18&user-date;  %B %-15f: %s%)\n"
;;      gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
;;      gnus-thread-sort-functions '(gnus-thread-sort-by-date)
;;      gnus-sum-thread-tree-false-root ""
;;      gnus-sum-thread-tree-indent " "
;;      gnus-sum-thread-tree-leaf-with-other "├► "
;;      gnus-sum-thread-tree-root ""
;;      gnus-sum-thread-tree-single-leaf "╰► "
;;      gnus-sum-thread-tree-vertical "│")

;; (setq gnus-user-date-format-alist
;;       '(((gnus-seconds-today) . "Today, %H:%M")
;;         ((+ 86400 (gnus-seconds-today)) . "Yesterday, %H:%M")
;;         (604800 . "%A %H:%M") ;;that's one week
;;         ((gnus-seconds-month) . "%A %d")
;;         ((gnus-seconds-year) . "%B %d")
;;         (t . "%B %d '%y"))) ;;this one is used when no other does match


;; turn off "original message" washing since zimbra doesn't produce messages
;; that work well with this function
(setq notmuch-wash-original-regexp "a^")
