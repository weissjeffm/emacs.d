(autoload 'notifications-notify "notifications")

;; (defcustom rcirc-authinfo nil
;;   "List of authentication passwords.
;; Each element of the list is a list with a SERVER-REGEXP string
;; and a method symbol followed by method specific arguments.

;; The valid METHOD symbols are `nickserv', `chanserv' and
;; `bitlbee'.

;; The ARGUMENTS for each METHOD symbol are:
;;   `nickserv': NICK PASSWORD [NICKSERV-NICK]
;;   `chanserv': NICK CHANNEL PASSWORD
;;   `bitlbee': NICK PASSWORD
;;   `quakenet': ACCOUNT PASSWORD

;; Examples:
;;  ((\"freenode\" nickserv \"bob\" \"p455w0rd\")
;;   (\"freenode\" chanserv \"bob\" \"#bobland\" \"passwd99\")
;;   (\"freenode\" userserv \"bob\" \"passwd99\")
;;   (\"bitlbee\" bitlbee \"robert\" \"sekrit\")
;;   (\"dal.net\" nickserv \"bob\" \"sekrit\" \"NickServ@services.dal.net\")
;;   (\"quakenet.org\" quakenet \"bobby\" \"sekrit\"))"
;;   :type '(alist :key-type (string :tag "Server")
;; 		:value-type (choice (list :tag "NickServ"
;; 					  (const nickserv)
;; 					  (string :tag "Nick")
;; 					  (string :tag "Password"))
;;                                     (list :tag "USERSERV"
;; 					  (const userserv)
;; 					  (string :tag "Nick")
;; 					  (string :tag "Password"))
;; 				    (list :tag "ChanServ"
;; 					  (const chanserv)
;; 					  (string :tag "Nick")
;; 					  (string :tag "Channel")
;; 					  (string :tag "Password"))
;; 				    (list :tag "BitlBee"
;; 					  (const bitlbee)
;; 					  (string :tag "Nick")
;; 					  (string :tag "Password"))
;;                                     (list :tag "QuakeNet"
;;                                           (const quakenet)
;;                                           (string :tag "Account")
;;                                           (string :tag "Password"))))
;;   :group 'rcirc)

(defun rcirc-check-auth-status (process sender args text)
  "Check if the user just authenticated.
If authenticated, runs `rcirc-authenticated-hook' with PROCESS as
the only argument."
  (with-rcirc-process-buffer process
    (when (and (not rcirc-user-authenticated)
               rcirc-authenticate-before-join
               rcirc-auto-authenticate-flag)
      (let ((target (car args))
            (message (cadr args)))
        (when (or
               (and ;; nickserv
                (string= sender "NickServ")
                (string= target rcirc-nick)
                (member message
                        (list
                         (format "You are now identified for \C-b%s\C-b." rcirc-nick)
			 (format "You are successfully identified as \C-b%s\C-b." rcirc-nick)
                         "Password accepted - you are now recognized."
                         )))
               (and ;; userserv
                (string= sender "USERSERV")
                (string= target rcirc-nick)
                (member message
                        (list
                         "Login successful"
                         )))
               (and ;; quakenet
                (string= sender "Q")
                (string= target rcirc-nick)
                (string-match "\\`You are now logged in as .+\\.\\'" message)))
          (setq rcirc-user-authenticated t)
          (run-hook-with-args 'rcirc-authenticated-hook process)
          (remove-hook 'rcirc-authenticated-hook 'rcirc-join-channels-post-auth t))))))

(defun rcirc-authenticate ()
  "Send authentication to process associated with current buffer.
Passwords are stored in `rcirc-authinfo' (which see)."
  (interactive)
  (with-rcirc-server-buffer
    (dolist (i rcirc-authinfo)
      (let ((process (rcirc-buffer-process))
	    (server (car i))
	    (nick (caddr i))
	    (method (cadr i))
	    (args (cdddr i)))
	(when (and (string-match server rcirc-server))
          (if (and (memq method '(nickserv chanserv bitlbee userserv))
                   (string-match nick rcirc-nick))
              ;; the following methods rely on the user's nickname.
              (case method
                (nickserv
                 (rcirc-send-privmsg
                  process
                  (or (cadr args) "NickServ")
                  (concat "IDENTIFY " (car args))))
                (userserv
                 (rcirc-send-privmsg
                  process
                  "USERSERV"
                  (concat "login " nick " " (car args)))) 
                (chanserv
                 (rcirc-send-privmsg
                  process
                  "ChanServ"
                  (format "IDENTIFY %s %s" (car args) (cadr args))))
                (bitlbee
                 (rcirc-send-privmsg
                  process
                  "&bitlbee"
                  (concat "IDENTIFY " (car args)))))
            ;; quakenet authentication doesn't rely on the user's nickname.
            ;; the variable `nick' here represents the Q account name.
            (when (eq method 'quakenet)
              (rcirc-send-privmsg
               process
               "Q@CServe.quakenet.org"
               (format "AUTH %s %s" nick (car args))))))))))

(defvar notification-sound-file "/usr/share/sounds/freedesktop/stereo/complete.oga")

(require 'rcirc-notify)

(defun my-notify (nick channel message)
  (start-process "notif" nil "play"
                 "-q" notification-sound-file)
  (condition-case ()
      (notifications-notify :title (format "%s in %s" nick channel)
                            ;; Remove duplicate spaces
                            :body (replace-regexp-in-string " +" " " message)
                            :sound-file notification-sound-file)
    (error nil)))

(defun rcirc-notify-allowed (nick &optional delay)
  "Return non-nil if a notification should be made for NICK.
If DELAY is specified, it will be the minimum time in seconds
that can occur between two notifications.  The default is
`rcirc-notify-timeout'."
  ;; Check current frame buffers
  (let ((rcirc-in-a-frame-p 
         (some (lambda (f)
                 (and (equal "rcirc" (cdr f))
                      (car f)))
               (mapcar (lambda (f) 
                         (let ((buffer (car (frame-parameter f 'buffer-list))))
                           (with-current-buffer buffer
                             (cons buffer mode-name))))
                       (visible-frame-list)))))
    (if (or (not rcirc-notify-check-frame)
            (and rcirc-notify-check-frame (not rcirc-in-a-frame-p)))
        (progn
          (unless delay (setq delay rcirc-notify-timeout))
          (let ((cur-time (float-time (current-time)))
                (cur-assoc (assoc nick rcirc-notify--nick-alist))
                (last-time))
            (if cur-assoc
                (progn
                  (setq last-time (cdr cur-assoc))
                  (setcdr cur-assoc cur-time)
                  (> (abs (- cur-time last-time)) delay))
              (push (cons nick cur-time) rcirc-notify--nick-alist)
              t))))))

(defun rcirc-notify-me (proc sender response target text)
  "Notify the current user when someone sends a message that
matches the current nick."
  (interactive)
  ;;(message "proc %S, sender %S, response %S, target %s, text %S, allowed %S" proc sender response target text (rcirc-notify-allowed sender) )
  (when (and (not (string= (rcirc-nick proc) sender))
	     (not (string= (rcirc-server-name proc) sender))
	     (rcirc-notify-allowed sender))
    (cond ((string-match (rcirc-nick proc) text)
	   ;; (rcirc-notify sender text)
           (my-notify sender target text))
	  (rcirc-notify-keywords
	   (let ((keyword (catch 'match
			    (dolist (key rcirc-keywords)
			      (when (string-match (concat "\\<" key "\\>")
						  text)
				(throw 'match key))))))
	     (when keyword
               (my-notify sender target text)
             ;;  (rcirc-notify-keyword sender keyword text)
               ))))))

(rcirc-notify-add-hooks)

(defun-rcirc-command reconnect (arg)
  "Reconnect the server process."
  (interactive "i")
  (if (buffer-live-p rcirc-server-buffer)
      (with-current-buffer rcirc-server-buffer
	(let ((reconnect-buffer (current-buffer))
	      (server (or rcirc-server rcirc-default-server))
	      (port (if (boundp 'rcirc-port) rcirc-port rcirc-default-port))
	      (nick (or rcirc-nick rcirc-default-nick))
	      channels)
	  (dolist (buf (buffer-list))
	    (with-current-buffer buf
	      (when (equal reconnect-buffer rcirc-server-buffer)
		(remove-hook 'change-major-mode-hook
			     'rcirc-change-major-mode-hook)
                (let ((server-plist (cdr (assoc-string server rcirc-server-alist)))) 
                  (when server-plist 
                    (setq channels (plist-get server-plist :channels))))
		  )))
	  (if process (delete-process process))
	  (rcirc-connect server port nick
			 nil
			 nil
			 channels)))))

;;; Attempt reconnection at increasing intervals when a connection is
;;; lost.

(defvar rcirc-reconnect-attempts 0)

;;;###autoload
(define-minor-mode rcirc-reconnect-mode
  nil
  nil
  " Auto-Reconnect"
  nil
  (if rcirc-reconnect-mode
      (progn
	(make-local-variable 'rcirc-reconnect-attempts)
	(add-hook 'rcirc-sentinel-hooks
		  'rcirc-reconnect-schedule nil t))
    (remove-hook 'rcirc-sentinel-hooks
		 'rcirc-reconnect-schedule t)))

(defun rcirc-reconnect-schedule (process &optional sentinel seconds)
  (condition-case err
      (when (and (eq 'closed (process-status process))
		 (buffer-live-p (process-buffer process)))
	(with-rcirc-process-buffer process
	  (unless seconds
	    (setq seconds (exp (1+ rcirc-reconnect-attempts))))
	  (rcirc-print
	   process "my-rcirc.el" "ERROR" rcirc-target
	   (format "scheduling reconnection attempt in %s second(s)." seconds) t)
	  (run-with-timer
	   seconds
	   nil
	   'rcirc-reconnect-perform-reconnect
	   process)))
    (error
     (rcirc-print process "RCIRC" "ERROR" nil
		  (format "%S" err) t)))
)

(defun rcirc-reconnect-perform-reconnect (process)
  (when (and (eq 'closed (process-status process))
	     (buffer-live-p (process-buffer process))
	     )
    (with-rcirc-process-buffer process
      (when rcirc-reconnect-mode
	(if (get-buffer-process (process-buffer process))
	    ;; user reconnected manually
	    (setq rcirc-reconnect-attempts 0)
	  (let ((msg (format "attempting reconnect to %s..."
			     (process-name process)
			     )))
	    (rcirc-print process "my-rcirc.el" "ERROR" rcirc-target
			 msg t))
	  ;; remove the prompt from buffers
	  (condition-case err
	      (progn
		(save-window-excursion
		  (save-excursion
		    (rcirc-cmd-reconnect nil)))
		(setq rcirc-reconnect-attempts 0))
	    ((quit error)
	     (incf rcirc-reconnect-attempts)
	     (rcirc-print process "my-rcirc.el" "ERROR" rcirc-target
			  (format "reconnection attempt failed: %s" err)  t)
	     (rcirc-reconnect-schedule process))))))))

(add-hook 'rcirc-mode-hook
          (lambda ()
            (if (string-match (regexp-opt '("irc.freenode.net"
                                            "irc.devel.redhat.com"))
                              (buffer-name))
                (rcirc-reconnect-mode 1))))
(remove-hook 'rcirc-mode-hook (first rcirc-mode-hook))

