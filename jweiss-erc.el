;;ERC
(setq nick-face-list '())
(setq erc-nick-uniquifier "_")

;; Define the list of colors to use when coloring IRC nicks.
(setq-default erc-colors-list '("pink" "light green" "yellow"
                                "gray" "thistle" "tan" "violet"
                                "mint cream" "white" "gold"
                                "dark khaki" "orange" "plum"
                                "light blue" "pale green"
                                "#ffeeaa" "#aaddff" "#bbeebb"))

(defun build-nick-face-list ()
  "build-nick-face-list builds a list of new faces using the
foreground colors specified in erc-colors-list. The nick faces
created here will be used to format IRC nicks."
  (setq i -1)
  (setq nick-face-list
        (mapcar
         (lambda (COLOR)
           (setq i (1+ i))
           (list (custom-declare-face
                  (make-symbol (format "erc-nick-face-%d" i))
                  (list (list t (list :foreground COLOR)))
                  (format "Nick face %d" i))))
         erc-colors-list)))

(defun my-insert-modify-hook ()
  "This insert-modify hook looks for nicks in new messages and
computes md5(nick) and uses substring(md5_value, 0, 4)
mod (length nick-face-list) to index the face list and produce
the same face for a given nick each time it is seen. We get a lot
of collisions this way, unfortunately, but it's better than some
other methods I tried. Additionally, if you change the order or
size of the erc-colors-list, you'll change the colors used for
nicks."
  (if (null nick-face-list) (build-nick-face-list))
  (save-excursion
    (goto-char (point-min))
    (if (looking-at "<\\([^>]*\\)>")
        (let ((nick (match-string 1)))
          (put-text-property (match-beginning 1) (match-end 1)
                             'face (nth
                                    (mod (string-to-number
                                          (substring (md5 nick) 0 4) 16)
                                         (length nick-face-list))
                                    nick-face-list))))))

;; This adds the ERC message insert hook.
(add-hook 'erc-insert-modify-hook 'my-insert-modify-hook)

(add-hook 'erc-after-connect
          '(lambda (SERVER NICK)
             (cond
              ((string-match "freenode\\.net" SERVER)
               (erc-message "PRIVMSG" "NickServ identify 111111jm"))

              ((string-match "irc\\.devel\\.redhat" SERVER)
               (erc-message "PRIVMSG" "userserv login jweiss 111111jm")))))

(defun irc-jweiss ()
  (interactive)
  (erc :server "irc.freenode.net" :port 6667 :nick "jweiss")
  (erc :server "irc.devel.redhat.com" :port 6667 :nick "jweiss"))

;;channel tracking
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))


(defun reset-erc-track-mode ()
  (interactive)
  (setq erc-modified-channels-alist nil)
  (erc-modified-channels-update))

(global-set-key (kbd "C-c r") 'reset-erc-track-mode)

(defadvice erc-track-find-face (around erc-track-find-face-promote-query activate)
  (if (erc-query-buffer-p)
      (setq ad-return-value (intern "erc-current-nick-face"))
    ad-do-it))

;;turn off auto-fill-mode which apparently breaks long lines into
;;multiple messages
(add-hook 'erc-mode-hook (lambda () (auto-fill-mode 0)))

;;notify
;;; Notify me when a keyword is matched (someone wants to reach me)
(autoload 'notifications-notify "notifications")
(setq erc-keywords '("jweiss"))
(erc-match-mode 1)

(defvar my-erc-page-nick-alist nil
  "Alist of nicks and the last time they tried to trigger a
notification")

(defvar my-erc-page-timeout 30
  "Number of seconds that must elapse between notifications from
the same person.")

(defvar notification-sound-file "/usr/share/sounds/freedesktop/stereo/complete.oga")

(defun my-erc-page-allowed (nick &optional delay)
  "Return non-nil if a notification should be made for NICK.
If DELAY is specified, it will be the minimum time in seconds
that can occur between two notifications.  The default is
`my-erc-page-timeout'."
  (unless delay (setq delay my-erc-page-timeout))
  (let ((cur-time (time-to-seconds (current-time)))
        (cur-assoc (assoc nick my-erc-page-nick-alist))
        (last-time))
    (if cur-assoc
        (progn
          (setq last-time (cdr cur-assoc))
          (setcdr cur-assoc cur-time)
          (> (abs (- cur-time last-time)) delay))
      (push (cons nick cur-time) my-erc-page-nick-alist)
      t)))

(defun my-erc-notify (nick channel message)
  (start-process "notif" nil "play"
                 "-q" notification-sound-file)
  (condition-case ()
      (notifications-notify :title (format "%s in %s" nick channel)
                            ;; Remove duplicate spaces
                            :body (replace-regexp-in-string " +" " " message)
                            :sound-file notification-sound-file)
    (error nil)))

(defun my-erc-page-me (match-type nick msg)
  "Notify the current user when someone sends a message that
matches a regexp in `erc-keywords'."
  (interactive)
                                        ;(message (format "page called: %s %s %s" match-type nick msg))
  (when (and (eq match-type 'keyword)
             ;; I don't want to see anything from the erc server
             (null (string-match "\\`\\([sS]erver\\|localhost\\)" nick))
             ;; or bots
             (null (string-match "\\(bot\\|serv\\)!" nick))
             ;; or from those who abuse the system
             (my-erc-page-allowed nick))
    (my-erc-notify (car (split-string nick "!"))
                   (or (erc-default-target) "#unknown") msg)))
(add-hook 'erc-text-matched-hook 'my-erc-page-me)

(defun my-erc-page-me-PRIVMSG (proc parsed)
  (let ((nick (car (erc-parse-user (erc-response.sender parsed))))
        (target (car (erc-response.command-args parsed)))
        (msg (erc-response.contents parsed)))
    (when (and (erc-current-nick-p target)
               (not (erc-is-message-ctcp-and-not-action-p msg))
               (my-erc-page-allowed nick))
      (my-erc-notify nick nick msg)
      nil)))
(add-hook 'erc-server-PRIVMSG-functions 'my-erc-page-me-PRIVMSG)

(defun my-notify-erc (match-type nickuserhost message)
  "Notify when a message is received."
  (notifications-notify :title (format "%s in %s"
                                       ;; Username of sender
                                       (car (split-string nickuserhost "!"))
                                       ;; Channel
                                       (or (erc-default-target) "#unknown"))
                        ;; Remove duplicate spaces
                        :body (replace-regexp-in-string " +" " " message)
                        :sound-file notification-sound-file))


;; erc fill columns dynamically and per buffer

;; (make-variable-buffer-local 'erc-fill-column)
;;  (add-hook 'window-configuration-change-hook
;;         '(lambda ()
;;            (save-excursion
;;              (walk-windows
;;               (lambda (w)
;;                 (let ((buffer (window-buffer w)))
;;                   (set-buffer buffer)
;;                   (when (eq major-mode 'erc-mode)
;;                     (setq erc-fill-column (- (window-width w) 2)))))))))
