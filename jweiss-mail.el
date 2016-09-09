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

(setq message-send-mail-function 'smtpmail-send-it)

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
      (quote ()))

(require 'eudc)

;; error about gnus-inhibit-images when running emacs 24
;; (require 'gnus-art) ;; http://notmuchmail.org/pipermail/notmuch/2012/012010.html

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
(setq eudc-server-hotlist '(("localhost" . bbdb)))

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
  ;;'(define-key message-mode-map (kbd "TAB") 'enz-eudc-expand-inline)

  '(define-key message-mode-map (kbd "TAB") 'message-tab))

(eval-after-load 'notmuch
  '(progn
     ;; (require 'dbus)
     
     ;; to untag all new messages
     (defun notmuch-untag-all-new ()
       (interactive)
       (notmuch-search-tag-all '("-new"))
       (notmuch-bury-or-kill-this-buffer))
     (define-key notmuch-search-mode-map (kbd "C-c C-k") 'notmuch-untag-all-new)
     (define-key notmuch-search-mode-map (kbd "=") 'notmuch-poll-and-refresh-this-buffer)
     (define-key notmuch-hello-mode-map (kbd "=") 'notmuch-poll-and-refresh-this-buffer)
     ;; Autorefresh notmuch-hello using D-Bus
     ;; (defun jweiss/notmuch-dbus-notify ()
     ;;   (save-excursion
     ;;     (save-restriction
     ;;       (when (get-buffer "*notmuch-hello*")
     ;;         (notmuch-hello-update t))))
     ;;   (save-excursion
     ;;     (save-restriction
     ;;       (when (get-buffer "*notmuch-saved-search-Inbox*")
     ;;         (notmuch-poll)))))
     ;; (ignore-errors
     ;;   (dbus-register-method :session dbus-service-emacs dbus-path-emacs
     ;;    		     dbus-service-emacs "NotmuchNewmail"
     ;;    		     'jweiss/notmuch-dbus-notify))
     
     ;;mark thread read
     (defun notmuch-mark-thread-read ()
       (interactive)
       (notmuch-search-tag "-unread")
       (notmuch-search-refresh-view))
     
     (define-key 'notmuch-search-mode-map (kbd "M-r") 'notmuch-mark-thread-read)

     ;; variable pitch commented out because notmuch can't handle it
     ;; esp for the search page, spacing is wrong
     
     ;;(add-hook 'notmuch-hello-mode-hook 'variable-pitch-mode)
     ;;(add-hook 'notmuch-show-hook 'variable-pitch-mode)
     (add-hook 'notmuch-search-hook (lambda ()
                                      ; (variable-pitch-mode) 
                                      (text-scale-set 1)))
     (require 'notmuch-address)
     (setq notmuch-address-command "/usr/local/bin/notmuch-addrlookup")
     (notmuch-address-message-insinuate)
     (setq notmuch-address-selection-function
           (lambda (prompt collection initial-input)
             (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history)))))

;; saved searches are private
(setq notmuch-saved-searches
      (car (read-from-string (secrets-get-secret "Login" "notmuch-saved-searches"))))

(defun notmuch-show-decrypt-message ()
  (interactive)
  ;; make sure the content is not indented, as this confuses epa
  (when notmuch-show-indent-content
    (notmuch-show-toggle-thread-indentation))

  (cl-letf ((extent (notmuch-show-message-extent))
            ((symbol-function 'y-or-n-p) #'(lambda (msg) t)))
    (epa-decrypt-armor-in-region (car extent) (cdr extent))))

(require 'notmuch)
(define-key 'notmuch-show-mode-map (kbd "C-c C-e d") 'notmuch-show-decrypt-message)
