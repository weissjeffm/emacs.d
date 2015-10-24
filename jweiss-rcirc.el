(autoload 'notifications-notify "notifications")

(require 'rcirc-notify)
(require 'rcirc-color)

;; desktop notifications

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
	   (when (and (catch 'match
                        (dolist (key rcirc-keywords)
                          (when (string-match (regexp-quote key)
                                              text)
                            (throw 'match key))))
                      (rcirc-notify-allowed sender))
             (my-notify sender target text))))))
 
(defun rcirc-notify-privmsg (proc sender response target text)
  "Notify the current user when someone sends a private message
to them."
  (interactive)
  (when (and (string= response "PRIVMSG")
             (not (string= sender (rcirc-nick proc)))
             (not (rcirc-channel-p target))
             (rcirc-notify-allowed sender))
    (my-notify sender target text)))

(rcirc-notify-add-hooks)

;; reconnect when network or server disconnects

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

; ignore buffers that aren't privmsg or channels i specify
(add-hook 'rcirc-mode-hook
          (lambda ()
            (let ((buf-name (buffer-name)))
              (setq rcirc-ignore-buffer-activity-flag
                    (not (or (string= "#monetas-dev@irc.monetas.io" buf-name)
                             (not (or (string-prefix-p "*" buf-name)
                                      (string-prefix-p "#" buf-name)))))))))

;(setq rcirc-mode-hook nil)
(defun rcirc-clear-all-activity ()
  "Clear out all the built up activity in the modeline"
  (interactive)
  (setq rcirc-activity '())
  (rcirc-update-activity-string))

(define-key rcirc-mode-map (kbd "C-c C-M-c") 'rcirc-clear-all-activity)

;; less chatty versions of these handlers
;; (only print when source nick was actually in this channel)

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

;; set account info from gnome-keyring

(setq rcirc-authinfo `(("irc.freenode.net" nickserv
                       ,(secrets-get-attribute "Login" "Freenode irc" :user)
                       ,(secrets-get-secret "Login" "Freenode irc"))
                       ("irc.monetas.io" nickserv
                        "jweiss"
                        ,(secrets-get-attribute "Login" "monetas irc" :nickserv-password))))
(setq rcirc-server-alist      
      `(("irc.freenode.net" :channels
        ("#rcirc" "#emacs" "#clojure" "#python" "#bitcoin" "#go-nuts"))
       ("irc.monetas.io" :nick "jweiss" :port 6697 :user-name ,(secrets-get-attribute "Login" "monetas irc" :user) :password ,(secrets-get-secret "Login" "monetas irc") :full-name "Jeff Weiss" :channels
        ("#monetas-dev" "#dev" "#gotary-clients")
        :encryption tls)))

;; deterministic nick colors
(setq rcirc-color-is-deterministic t)

;; load backlog when opening channel buffer
(defcustom rcirc-channel-log-lines 30
  "Number of lines of previous log to load when opening a channel
  buffer."
  :type 'integer
  :group 'rcirc)

(defun tail-file-to-string (filename num-lines)
  (interactive "f")
  (condition-case nil
      (save-excursion
        (with-temp-buffer
          (insert-file-contents filename)
          (end-of-buffer)
          (forward-line (- num-lines))
          (buffer-substring-no-properties (point) (point-max))))
    ('error "")))

(defun insert-partial-log ()
  (beginning-of-buffer)
  (let ((inhibit-read-only t))
    (insert (tail-file-to-string
             (expand-file-name (funcall rcirc-log-filename-function
                                        (rcirc-buffer-process) rcirc-target)
                               rcirc-log-directory)
             rcirc-channel-log-lines))
    (setq-local rcirc-prompt-start-marker (point-max-marker))
    (setq-local rcirc-prompt-end-marker (point-max-marker))
    (rcirc-update-prompt)
    (goto-char rcirc-prompt-end-marker)))

(add-hook 'rcirc-mode-hook 'insert-partial-log)
