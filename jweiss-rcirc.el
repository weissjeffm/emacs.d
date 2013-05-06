(autoload 'notifications-notify "notifications")

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
