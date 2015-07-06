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

;; fix alternate nick to append underscore instead of backtick
(require 'rcirc-notify)
(require 'rcirc-color)


(defun rcirc-handler-433 (process sender args text)
  "ERR_NICKNAMEINUSE"
  (rcirc-handler-generic process "433" sender args text)
  (let* ((new-nick (concat (cadr args) "_")))
    (with-rcirc-process-buffer process
      (rcirc-cmd-nick new-nick nil process))))

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
  (unless delay (setq delay rcirc-notify-timeout))
  (let ((cur-time (time-to-seconds (current-time)))
        (cur-assoc (assoc nick rcirc-notify--nick-alist))
        (last-time))
    (if cur-assoc
        (progn
          (setq last-time (cdr cur-assoc))
          (setcdr cur-assoc cur-time)
          (> (abs (- cur-time last-time)) delay))
      (push (cons nick cur-time) rcirc-notify--nick-alist)
      t)))

(defun rcirc-notify-me (proc sender response target text)
  "Notify the current user when someone sends a message that
matches the current nick or keywords."
  (interactive)
  (when (and (not (string= (rcirc-nick proc) sender))
	     (not (string= (rcirc-server-name proc) sender)))
    (cond ((and (string-match (concat "\\b" (rcirc-nick proc) "\\b") text)
                (rcirc-notify-allowed sender))
	  ;; (my-rcirc-notify sender text)
          (my-notify sender target text) )
	  (rcirc-notify-keywords
	   (let (keywords)
             (dolist (key rcirc-keywords keywords)
               (when (string-match (concat "\\<" key "\\>")
                                   text)
                 (push key keywords)))
	     (when keywords
               (if (rcirc-notify-allowed sender)
                   ;;(my-rcirc-notify-keyword sender keywords text)
                   (my-notify sender target text))))))))

(defun rcirc-notify-privmsg (proc sender response target text)
  "Notify the current user when someone sends a private message
to them."
  (interactive)
  (when (and (string= response "PRIVMSG")
             (not (string= sender (rcirc-nick proc)))
             (not (rcirc-channel-p target))
             (rcirc-notify-allowed sender))
    (my-notify sender target text)))

;; reconnect
(defvar rcirc-reconnections nil)

(defun rcirc-enable-reconnection (server &optional port nick user-name
                                         full-name startup-channels password encryption)
  (setq rcirc-reconnections
        (plist-put rcirc-reconnections server
                   (apply-partially
                    'rcirc-connect server port nick user-name full-name startup-channels password encryption))))

(advice-add 'rcirc-connect :before #'rcirc-enable-reconnection)

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
	    (setq seconds (if (< rcirc-reconnect-attempts 50)
                              (+ 10 (exp (* rcirc-reconnect-attempts 0.1)))
                              45))) 
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
		  (format "%S" err) t))))

(defun rcirc-reconnect-perform-reconnect (process)
  (when (and (eq 'closed (process-status process))
	     (buffer-live-p (process-buffer process)))
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
                    (funcall (plist-get rcirc-reconnections rcirc-server))))
		(setq rcirc-reconnect-attempts 0))
	    ((quit error)
	     (incf rcirc-reconnect-attempts)
	     (rcirc-print process "my-rcirc.el" "ERROR" rcirc-target
			  (format "reconnection attempt failed: %s" err)  t)
	     (rcirc-reconnect-schedule process))))))))

(add-hook 'rcirc-mode-hook
          (lambda ()
            (if (string-match (regexp-opt (mapcar 'car rcirc-server-alist))
                              (buffer-name))
                (rcirc-reconnect-mode 1))))

(defun rcirc-clear-all-activity ()
  (interactive)
  (setq rcirc-activity '())
  (rcirc-update-activity-string))

(defun rcirc-handler-NICK (process sender args text)
  (let* ((old-nick sender)
         (new-nick (car args))
         (channels (rcirc-nick-channels process old-nick)))
    ;; update list of ignored nicks
    (rcirc-ignore-update-automatic old-nick)
    (when (member old-nick rcirc-ignore-list)
      (add-to-list 'rcirc-ignore-list new-nick)
      (add-to-list 'rcirc-ignore-list-automatic new-nick))
    ;; print message to my+nick's channels
    (dolist (target channels)
      (when (member target (rcirc-nick-channels process (rcirc-nick process)))
        (rcirc-print process sender "NICK" target new-nick)))
    ;; update private chat buffer, if it exists
    (let ((chat-buffer (rcirc-get-buffer process old-nick)))
      (when chat-buffer
	(with-current-buffer chat-buffer
	  (rcirc-print process sender "NICK" old-nick new-nick)
	  (setq rcirc-target new-nick)
	  (rename-buffer (rcirc-generate-new-buffer-name process new-nick)))))
    ;; remove old nick and add new one
    (with-rcirc-process-buffer process
      (let ((v (gethash old-nick rcirc-nick-table)))
        (remhash old-nick rcirc-nick-table)
        (puthash new-nick v rcirc-nick-table))
      ;; if this is our nick...
      (when (string= old-nick rcirc-nick)
        (setq rcirc-nick new-nick)
	(rcirc-update-prompt t)
        ;; reauthenticate
        (when rcirc-auto-authenticate-flag (rcirc-authenticate))))))

(defun rcirc-handler-QUIT (process sender args text)
  (rcirc-ignore-update-automatic sender)
  (mapc (lambda (channel)
	  ;; broadcast quit message each channel
	  (when (member channel (rcirc-nick-channels process (rcirc-nick process)))
            (rcirc-print process sender "QUIT" channel (apply 'concat args)))
	  ;; record nick in quit table if they recently spoke
	  (rcirc-maybe-remember-nick-quit process sender channel))
	(rcirc-nick-channels process sender))
  (rcirc-nick-remove process sender))

(define-key rcirc-mode-map (kbd "C-c C-M-c") 'rcirc-clear-all-activity)

(rcirc-notify-add-hooks)

;;set account info from gnome-keyring
(setq rcirc-authinfo `(("irc.freenode.net" nickserv
                       ,(secrets-get-attribute "Login" "Freenode irc" :user)
                       ,(secrets-get-secret "Login" "Freenode irc"))))
(setq rcirc-server-alist      
      `(("irc.freenode.net" :channels
        ("#rcirc" "#emacs" "#clojure" "#python" "#bitcoin" "#go-nuts"))
       ("irc.monetas.io" :nick "jweiss" :port 6697 :user-name ,(secrets-get-attribute "Login" "monetas irc" :user) :password ,(secrets-get-secret "Login" "monetas irc") :full-name "Jeff Weiss" :channels
        ("#monetas-dev" "#dev")
        :encryption tls)))

;; deterministic nick colors
(setq rcirc-color-is-deterministic t)

