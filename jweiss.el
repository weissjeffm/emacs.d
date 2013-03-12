;;time loading of this file
(require 'cl) ; a rare necessary use of REQUIRE (for mwe-log-commands?)


;;disable suspending emacs on ctrl-z
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-z"))
                                        ;jump to line
(global-set-key (kbd "C-c M-l") 'goto-line)
                                        ;buffer switch
;;(global-set-key (kbd "C-,") 'ido-switch-buffer)
;;(global-set-key [insert] 'ido-switch-buffer)
(global-set-key [insert] 'switch-to-buffer)

;;frame-switch
(global-set-key (kbd "C-q") 'windmove-up)
(global-set-key (kbd "C-z") 'windmove-down)
(global-set-key (kbd "S-<left>") 'windmove-left)
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<up>") 'windmove-up)
(global-set-key (kbd "S-<down>") 'windmove-down)
;;use ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
;;use ace-jump-mode
(global-set-key (kbd "C-'") 'ace-jump-mode)
(setq ace-jump-mode-scope 'frame) ;;current frame only
(setq ace-jump-mode-move-keys ;;lower case hotkeys only
      (loop for i from ?a to ?z collect i))
;;others
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "<f12>") 'nrepl-jack-in)
(autoload 'nrepl-mode-map "nrepl")

;;hippie expand
(global-set-key (kbd "M-/") 'hippie-expand)

;;find file in project
(global-set-key (kbd "C-c C-f") 'find-file-in-project)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

(global-set-key (kbd "<f2>") 'magit-status)

;;; Enhance Lisp Modes

(define-key read-expression-map (kbd "TAB") 'lisp-complete-symbol)
(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)

;;Green/red diff colors
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))

(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-add "green4")
     (set-face-foreground 'magit-diff-del "red3")))

;;allow narrow to region 
(put 'narrow-to-region 'disabled nil)

;; y instead of yes
(defalias 'yes-or-no-p 'y-or-n-p)

;;fix crazy paredit keybindings
(require 'paredit)
(dolist (mode '(scheme emacs-lisp lisp clojure clojurescript eshell))
    (when (> (display-color-cells) 8)
      (font-lock-add-keywords (intern (concat (symbol-name mode) "-mode"))
                              '(("(\\|)" . 'esk-paren-face))))
    (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
              'paredit-mode))
(define-key paredit-mode-map (kbd "C-<left>") 'paredit-backward-slurp-sexp)
(define-key paredit-mode-map (kbd "C-M-<left>") 'paredit-backward-barf-sexp)
(define-key paredit-mode-map (kbd "C-M-<right>") 'paredit-forward-barf-sexp)
(define-key paredit-mode-map (kbd "M-(") 'paredit-wrap-round)

;;use imenu to search for symbols
(global-set-key (kbd "C-o") 'imenu)

;;use w tiling window mgr
(setq pop-up-frames nil)

;;associate some file extensions with modes
(add-to-list 'auto-mode-alist '("\\.*repo$" . conf-unix-mode))

;;use variable width for some buffers
(add-hook 'erc-mode-hook (lambda () (variable-pitch-mode t)))
(add-hook 'Info-mode-hook (lambda () (variable-pitch-mode t)))
(add-hook 'help-mode-hook (lambda () (variable-pitch-mode t)))
(desktop-save-mode 1)

;;auto-complete,
(autoload 'ac-config-default "auto-complete-config")
(ac-config-default)
(define-key ac-completing-map "\C-s" 'ac-isearch) ; not sure
                                        ; why this is necessary

                                        ;(add-to-list 'ac-dictionary-directories "~/.emacs.d/jweiss/ac-dict")
(autoload 'ac-nrepl-setup "ac-nrepl")
(add-hook 'clojure-mode-hook 'ac-nrepl-setup)
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
            (("^[a-zA-Z0-9-.*+!_?]+?>" . 'nrepl-prompt-face)))))

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
(autoload 'clojure-mode-map "clojure-mode" nil nil 'keymap)
(set-clojure-colors 'clojure-mode)
(set-clojure-colors 'nrepl-mode)


(add-hook 'clojure-mode-hook
          (lambda ()
            (define-key clojure-mode-map (kbd "<f8>") 'align-locators)
            (define-key clojure-mode-map (kbd "M-[") 'paredit-wrap-square)
            (define-key clojure-mode-map (kbd "M-{") 'paredit-wrap-curly)))

(add-hook 'nrepl-mode-hook
          (lambda ()
            (paredit-mode)
            (define-key nrepl-mode-map [C-S-up] 'nrepl-previous-matching-input)
            (define-key nrepl-mode-map (kbd "M-<f12>") 'nrepl-quit)
            (define-key nrepl-mode-map (kbd "M-j") 'nrepl-newline-and-indent)
            (auto-complete-mode)
            (ac-nrepl-setup)
            (font-lock-mode nil)
            (clojure-mode-font-lock-setup)
            (font-lock-mode t)))

(add-hook 'nrepl-interaction-mode-hook
          'nrepl-turn-on-eldoc-mode)

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


;;syntax highlight RoR log files
(require 'generic-x)

(define-generic-mode
    'error-log-mode ;; name of the mode to create
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


;;command logging
;;(autoload 'mwe:log-keyboard-commands "mwe-log-commands")
;;(eval-after-load 'mwe-log-commands
;;(add-hook 'after-change-major-mode-hook 'mwe:log-keyboard-commands))

(setq-default mwe:*log-keyboard-commands* t)
(setq mwe:*log-command-exceptions*
      '(nil self-insert-command backward-char forward-char
            delete-char delete-backward-char backward-delete-char
            backward-delete-char-untabify
            universal-argument universal-argument-other-key
            universal-argument-minus universal-argument-more
            recenter handle-switch-frame
            newline previous-line next-line mouse-set-point
            mouse-drag-region  paredit-open-round
            paredit-open-curly paredit-open-angled paredit-backward-delete
            right-char left-char paredit-doublequote paredit-semicolon
            paredit-open-square reindent-then-newline-and-indent))


(defun shell-at-host (target)
  (interactive (list (read-directory-name "Target Location: " "/")))
  (message target)
  (let ((default-directory target))
    (shell (file-remote-p target 'host))))

(defun directory-files-recursive (directory)
  "List the files in DIRECTORY and in its sub-directories."
  (interactive "DDirectory name: ")
  (let (el-files-list
        (current-directory-list
         (directory-files-and-attributes directory t)))
    (while current-directory-list
      ;; check whether filename is that of a directory
      (if (eq t (car (cdr (car current-directory-list))))
          ;; decide whether to skip or recurse
          (if (equal "." (substring (car (car current-directory-list)) -1))
              ()

            (setq el-files-list
                  (append
                   (directory-files-recursive
                    (car (car current-directory-list)))
                   el-files-list)))
        ;; check to see whether filename ends in `.el'
        ;; and if so, append its name to a list.
        (setq el-files-list
              (cons (car (car current-directory-list)) el-files-list)))
      ;; move to the next filename in the list; this also
      ;; shortens the list so the while loop eventually comes to an end
      (setq current-directory-list (cdr current-directory-list)))
    ;; return the filenames
    el-files-list))

(defun search-project-for-sexp-at-point ()
  ;;requires icicles and magit
  (interactive)
  (apply #'icicle-search nil nil (thing-at-point 'sexp) t
         (directory-files-recursive
          (concat (magit-get-top-dir (file-name-directory (buffer-file-name)))
                  "/src"))
         '()))

;;(global-set-key (kbd "<f9>") 'search-project-for-sexp-at-point)

(defun align-locators ()
  (interactive)
  (mark-sexp)
  (align-regexp (region-beginning) (region-end) "\\(\\s-*\\)[\\\"|\\(]"))



(autoload 'notmuch "notmuch" nil t)
(autoload 'icy-mode "icicles" nil t)

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

;; put completions buffer at bottom

(add-to-list 'special-display-buffer-names '("*Completions*" my-display-completions))

(defun my-display-completions (buf)
  "put the *completions* buffer at the bottom"
  (let ((window (car (last (delete (minibuffer-window) (window-list)))))) 
    (let ((comp-window (condition-case nil
                           (split-window-vertically window nil 'below)
                         (error window))))
      (set-window-buffer comp-window buf)
      comp-window)))
