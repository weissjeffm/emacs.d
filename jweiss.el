;;time loading of this file
(require 'cl) ; a rare necessary use of REQUIRE
(defvar *emacs-load-start* (current-time))

;;disable suspending emacs on ctrl-z
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-z"))
;jump to line
(global-set-key (kbd "C-c M-l") 'goto-line)
;buffer switch 
(global-set-key (kbd "C-,") 'ido-switch-buffer)
;;frame-switch
(global-set-key (kbd "C-q") 'windmove-up)
(global-set-key (kbd "C-z") 'windmove-down)

;;use w tiling window mgr
(setq pop-up-frames nil)

;;basic colors
(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
(global-hl-line-mode 1)
(set-face-background 'hl-line "#151500")

(desktop-save-mode 1)

;;auto-complete, ac-slime
(autoload 'set-up-slime-ac "ac-slime")
(autoload 'ac-config-default "auto-complete-config")
(ac-config-default)
(autoload 'slime-repl-mode "slime") 
(add-to-list 'ac-dictionary-directories "~/.emacs.d/jweiss/ac-dict")
(add-to-list 'ac-modes 'slime-repl-mode)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

;;org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; More syntax coloring
(defun tweak-clojure-syntax (mode)
  (mapcar (lambda (x) (font-lock-add-keywords mode x))
          '((("#?['`]*(\\|)" . 'clojure-parens))
            (("#?\\^?{\\|}" . 'clojure-braces))
            (("\\[\\|\\]" . 'clojure-brackets))
            ((":\\w+" . 'clojure-keyword))
            (("#?\"" 0 'clojure-double-quote prepend))
            (("nil\\|true\\|false\\|%[1-9]?" . 'clojure-special))
            (("(\\(\\.[^ \n)]*\\|[^ \n)]+\\.\\|new\\)\\([ )\n]\\|$\\)" 1
              'clojure-java-call))
            (("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 'font-lock-warning-face t))
            (("(\\(fn\\>\\)" 0 (progn (compose-region (match-beginning 1)
                                                      (match-end 1) "ƒ") nil)))
            (("(\\(->\\>\\)" 0 (progn (compose-region (match-beginning 1)
                                                      (match-end 1) "→") nil)))
            (("(\\(->>\\>\\)" 0 (progn (compose-region (match-beginning 1)
                                                       (match-end 1) "↠") nil)))
            (("(\\(complement\\>\\)" 0 (progn (compose-region
                                               (match-beginning 1)
                                               (match-end 1) "¬") nil)))
            (("^[a-zA-Z0-9-.*+!_?]+?>" . 'slime-repl-prompt-face)))))

;; Macro for face definition
(defmacro defcljface (name color desc &optional others)
  `(defface ,name '((((class color)) (:foreground ,color ,@others)))
     ,desc :group 'faces))

;; Define extra clojure faces
(defcljface clojure-parens       "DimGrey"   "Clojure parens")
(defcljface clojure-braces       "#49b2c7"   "Clojure braces")
(defcljface clojure-brackets     "#0074e8"   "Clojure brackets")
(defcljface clojure-keyword      "#45b8f2"   "Clojure keywords")
(defcljface clojure-namespace    "#a9937a"   "Clojure namespace")
(defcljface clojure-java-call    "#7587a6"   "Clojure Java calls")
(defcljface clojure-special      "#0074e8"   "Clojure special")
(defcljface clojure-double-quote "#00920A"   "Clojure special")

;;clojure colors
(defun set-clojure-colors (mode-fn)
  (tweak-clojure-syntax mode-fn)
  (set-face-foreground 'font-lock-string-face "#ffddaa")
  (set-face-foreground 'clojure-parens "gray27")
  (set-face-attribute 'clojure-parens nil :underline nil :bold t)
  (set-face-foreground 'clojure-brackets "#445f5f")
  (set-face-attribute 'clojure-brackets nil :underline nil :bold t)
  (set-face-foreground 'clojure-double-quote "LightSalmon")
  (set-face-foreground 'clojure-braces "#666644")
  (set-face-attribute 'clojure-braces nil :underline nil :bold t)
  (set-face-foreground 'clojure-keyword "#ffcccc")
  (set-face-attribute 'clojure-keyword nil :underline nil :bold nil :italic t)
  (set-face-foreground 'font-lock-keyword-face "#eeaaff")
  (set-face-attribute 'font-lock-keyword-face nil :underline nil :bold t :italic nil)
  (set-face-foreground 'clojure-java-call "#ccffcc")
  (set-face-foreground 'clojure-namespace "#0000ff")
  (set-face-attribute 'clojure-namespace nil :underline nil :bold t)

  (set-face-attribute 'font-lock-function-name-face nil :underline nil :bold t)
  (set-face-foreground 'font-lock-function-name-face "#ffeeaa")
  (set-face-attribute 'font-lock-builtin-face nil :underline nil :bold t)
  (set-face-foreground 'font-lock-builtin-face "#aaddff")

  (set-face-foreground 'clojure-special "#bbbbff")
  (set-face-attribute 'clojure-special nil :underline nil :bold t :italic t))

(autoload 'clojure-mode "clojure-mode")
(set-clojure-colors 'clojure-mode)
(set-clojure-colors 'slime-repl-mode)

(add-hook 'eshell-mode-hook 
          (lambda()(paredit-mode 1)))

;(add-hook 'clojure-mode-hook 'durendal-enable-auto-compile)
(add-hook 'slime-repl-mode-hook 'durendal-slime-repl-paredit)

(add-hook 'sldb-mode-hook 'durendal-dim-sldb-font-lock)
;(add-hook 'slime-compilation-finished-hook 'durendal-hide-successful-compile)

(autoload 'yas/initialize "yasnippet")
(yas/initialize)
(setq yas/root-directory '("~/.emacs.d/snippets"
                           "~/.emacs.d/elpa/yasnippet-0.6.1/snippets"))
(mapc 'yas/load-directory yas/root-directory)


(add-hook 'clojure-mode-hook 'yas/minor-mode-on)
(add-hook 'clojure-mode-hook 
          (lambda () 
            (define-key clojure-mode-map (kbd "M-[") 'paredit-wrap-square)
            (define-key clojure-mode-map (kbd "M-{") 'paredit-wrap-curly)))
(eval-after-load 'clojure-mode (yas/reload-all))

(autoload 'paredit-wrap-square "paredit")
(add-hook 'slime-connected-hook
          (lambda () 
            (define-key slime-mode-map " " 'slime-space)
            (define-key slime-mode-map (kbd "M-[") 'paredit-wrap-square)
            (define-key slime-mode-map (kbd "M-{") 'paredit-wrap-curly)
            (define-key slime-repl-mode-map [C-S-up] 'slime-repl-previous-matching-input)))


(defun goto-last-edit-point ()
  "Go to the last point where editing occurred."
  (interactive)
  (let ((undos buffer-undo-list))
    (when (listp undos)
      (while (and undos
		  (let ((pos (or (cdr-safe (car undos))
				 (car undos))))
		    (not (and (integerp pos)
			      (goto-char (abs pos))))))
	(setq undos (cdr undos))))))
(global-set-key (kbd "C-c SPC") 'goto-last-edit-point)

;;browse link shortcut
(global-set-key (kbd "C-c M-b") 'browse-url-at-point)

;;ERC
(setq nick-face-list '())
(setq erc-nick-uniquifier "_")

;;logging
(setq erc-log-channels-directory "~/.erc/logs/")
(setq erc-save-buffer-on-part nil
      erc-save-queries-on-quit nil
      erc-log-write-after-send t
      erc-log-write-after-insert t)

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

;;autojoin
(setq erc-autojoin-channels-alist
      '(("freenode.net" "#emacs" "#clojure" "#katello" "#pulp")
        ("devel.redhat.com" "#cloud-qe" "#systemengine" "#systemengine-qe" "#candlepin")))

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

(defvar my-erc-page-timeout 10
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


;;syntax highlight RoR log files
(require 'generic-x) 

(define-generic-mode 
    'ror-log-mode ;; name of the mode to create
  '("!!")         ;; comments start with '!!'
  '("ERROR" "WARN" 
    "DEBUG" "INFO")                        ;; some keywords
  '(("^\\[.*\\]" . font-lock-comment-face) 
    ("[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} \\([0-9]\\{2\\}:\\)+[0-9]\\{2\\}" . 'font-lock-type-face)
    ("/.*:in `.*'$" . 'font-lock-warning-face)
    ("/.*:[0-9]+$" . 'font-lock-warning-face)) ;; ';' is a a built-in 
  '("production.log")        ;; files for which to activate this mode 
  nil                        ;; other functions to call
  "A mode for RoR log files" ;; doc string for this mode
  )

(message "My .emacs loaded in %ds" (destructuring-bind (hi lo ms) (current-time)
                           (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))

