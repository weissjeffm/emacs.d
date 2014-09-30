;;time loading of this file
(require 'cl) ; a rare necessary use of REQUIRE (for mwe-log-commands?)

;;disable suspending emacs on ctrl-z
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "<f11>") 'make-frame)
(global-unset-key (kbd "C-x C-z"))
                                        ;jump to line
(global-set-key (kbd "C-c M-l") 'goto-line)
                                        ;buffer switch
;;(global-set-key (kbd "C-,") 'ido-switch-buffer)
;;(global-set-key [insert] 'ido-switch-buffer)
(global-set-key (kbd "C-q") 'switch-to-buffer)

;;frame-switch
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
(global-set-key (kbd "<f12>") 'cider-jack-in)
(global-set-key (kbd "<f3>") 'find-file)
(global-set-key (kbd "<f4>") 'find-file-in-project)
;(autoload 'nrepl-mode-map "nrepl")

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

;;Navigating elisp
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))

;;undo tree
(autoload 'global-undo-tree-mode "undo-tree")
(global-undo-tree-mode)

;; Multiple cursors
(require 'multiple-cursors)
(define-prefix-command 'mc-key-map)
(global-set-key (kbd "C-c m") 'mc-key-map)

(define-key mc-key-map (kbd ".") 'mc/mark-all-symbols-like-this)
(define-key mc-key-map (kbd "M-.") 'mc/mark-all-symbols-like-this-in-defun)
(define-key mc-key-map (kbd ",") 'mc/mark-all-like-this-dwim)
(define-key mc-key-map (kbd "/") 'mc/mark-more-like-this-extended)
(define-key mc-key-map (kbd "s") 'mc/mark-next-symbol-like-this)

;; (global-set-key (kbd "C-c C-.") 'mc/mark-all-symbols-like-this)
;; (global-set-key (kbd "C-c M-.") 'mc/mark-all-symbols-like-this-in-defun)
;; (global-set-key (kbd "C-c C-,") 'mc/mark-all-like-this-dwim)
;; (global-set-key (kbd "C-c C-/") 'mc/mark-more-like-this-extended)
;; (global-set-key (kbd "C-M-s") 'mc/mark-next-symbol-like-this)
(define-key mc/keymap (kbd "TAB") 'mc/cycle-forward)

;;Green/red diff colors
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))

;; y instead of yes
(defalias 'yes-or-no-p 'y-or-n-p)

;;smartparens keybindings
(require 'smartparens)
(defface esk-paren-face
   '((((class color) (background dark))
      (:foreground "grey50"))
     (((class color) (background light))
      (:foreground "grey55")))
   "Face used to dim parentheses."
   :group 'starter-kit-faces)

(dolist (mode '(scheme emacs-lisp lisp clojure clojurescript eshell))
    (when (> (display-color-cells) 8)
      (font-lock-add-keywords (intern (concat (symbol-name mode) "-mode"))
                              '(("(\\|)" . 'esk-paren-face))))
    (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
              'smartparens-mode))
(add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)
(sp-pair "(" ")" :wrap "M-(")
;; no '' pair in lisp
(sp-local-pair '(emacs-lisp-mode clojure-mode) "'" nil :actions nil)
;;use w tiling window mgr
(setq pop-up-frames nil)

;;associate some file extensions with modes
(add-to-list 'auto-mode-alist '("\\.*repo$" . conf-unix-mode))

;;use variable width for some buffers
(defun my-set-variable-pitch ()
  (variable-pitch-mode t))
(add-hook 'erc-mode-hook 'my-set-variable-pitch)
(add-hook 'rcirc-mode-hook 'my-set-variable-pitch)
(add-hook 'Info-mode-hook 'my-set-variable-pitch)
(add-hook 'help-mode-hook 'my-set-variable-pitch)
(desktop-save-mode 1)

;;auto-complete,
(autoload 'ac-config-default "auto-complete-config")
(ac-config-default)
(define-key ac-completing-map "\C-s" 'ac-isearch) ; not sure
                                        ; why this is necessary

                                        ;(add-to-list 'ac-dictionary-directories "~/.emacs.d/jweiss/ac-dict")
;(autoload 'ac-nrepl-setup "ac-nrepl")
;(add-hook 'clojure-mode-hook 'ac-nrepl-setup)
;(remove-hook 'clojure-mode-hook 'ac-nrepl-setup)
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
            ;; (("(\\(fn\\>\\)" 0 (progn (compose-region (match-beginning 1)
            ;;                                           (match-end 1) "ƒ") nil)))
            ;; (("(\\(->\\>\\)" 0 (progn (compose-region (match-beginning 1)
            ;;                                           (match-end 1) "→") nil)))
            ;; (("(\\(->>\\>\\)" 0 (progn (compose-region (match-beginning 1)
            ;;                                            (match-end 1) "↠") nil)))
            ;; (("(\\(complement\\>\\)" 0 (progn (compose-region
            ;;                                    (match-beginning 1)
            ;;                                    (match-end 1) "¬") nil))) 
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
;(set-clojure-colors 'nrepl-mode)


;; (defun show-nrepl ()
;;   (interactive)
;;   (switch-to-buffer "*nrepl*"))
;; (global-set-key (kbd "<f9>") 'show-nrepl)

;; (defun nrepl-pst ()
;;   (interactive)
;;   (insert "(clojure.repl/pst 100)")
;;   (nrepl-return))

;; (defun switch-to-nrepl-ns ()
;;   (nrepl-set-ns (plist-get
;;                  (nrepl-send-string-sync "(symbol (str *ns*))") :value)))

(add-hook 'clojure-mode-hook
          (lambda ()
            (define-key clojure-mode-map (kbd "<f8>") 'align-locators)
            (define-key clojure-mode-map (kbd "M-[") 'paredit-wrap-square)
            (define-key clojure-mode-map (kbd "M-{") 'paredit-wrap-curly)))

;; (add-hook 'nrepl-mode-hook
;;           (lambda ()
;;             (paredit-mode)
;;             (define-key nrepl-mode-map [C-S-up] 'nrepl-previous-matching-input)
;;             (define-key nrepl-mode-map (kbd "M-<f12>") 'nrepl-close)
;;             (define-key nrepl-mode-map (kbd "M-j") 'nrepl-newline-and-indent)
;;             ;(define-key nrepl-mode-map (kbd "C-x C-e") 'nrepl-eval-last-expression)
;;             (define-key nrepl-mode-map (kbd "<f7>") 'nrepl-pst)
;;             ;(define-key nrepl-mode-map (kbd "M-.") 'nrepl-jump)
;;             (define-key nrepl-interaction-mode-map (kbd "C-c C-z") 'nrepl-switch-to-repl-buffer)

            
;;             (auto-complete-mode)
;;             (ac-nrepl-setup)
;;             (font-lock-mode nil)
;;             (clojure-mode-font-lock-setup)
;;             (font-lock-mode t)))

;; (add-hook 'nrepl-connected-hook 
;;           (lambda ()
;;             (nrepl-set-ns (plist-get
;;                            (nrepl-send-string-sync "(symbol (str *ns*))") :value))))

;; (add-hook 'nrepl-interaction-mode-hook
;;           'nrepl-turn-on-eldoc-mode)

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
  "List the files in DIRECTORY and in its sub-directories. Skip broken symlinks."
  (interactive "DDirectory name: ")
  (let (files-list
        (current-directory-list (directory-files-and-attributes directory t)))
    (while current-directory-list
      ;; check whether filename is that of a directory
      (let ((filename (caar current-directory-list)))
        (if (eq t (cadar current-directory-list))
            ;; decide whether to skip or recurse
            (if (equal "." (substring filename -1))
                ()
              (setq files-list
                    (append
                     (directory-files-recursive filename)
                     files-list)))
          ;; append its name to a list. 
          (let ((sym-target (file-symlink-p filename)))
            (when (or (not sym-target) (file-exists-p sym-target))
              (setq files-list (cons filename files-list))))))  
      ;; move to the next filename in the list; this also
      ;; shortens the list so the while loop eventually comes to an end
      (setq current-directory-list (cdr current-directory-list)))
    ;; return the filenames
    files-list))

(autoload 'magit-get-top-dir "magit" nil t)
(defun magit-project-dir ()
  (magit-get-top-dir (file-name-directory (or (buffer-file-name) default-directory))))

(defun search-project (s)
  (interactive "sSearch project for regex: ")
  (apply #'icicle-search nil nil s t
         (directory-files-recursive
          (let* ((magit-proj-dir (magit-project-dir))
                 (src-subdir (concat magit-proj-dir "/src")))
            (if (file-exists-p src-subdir)
                src-subdir
              magit-proj-dir)))
         '()))

(defun search-project-for-sexp-at-point ()
  ;;requires icicles and magit
  (interactive)
  (search-project (thing-at-point 'symbol)))

(global-set-key (kbd "<f6>") 'search-project-for-sexp-at-point)

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

;; eshell
(defun eshell-shell-at-pwd ()
  "Opens a shell at the pwd of eshell"
  (interactive)
  (shell (eshell/pwd)))

(defun show-eshell ()
  (interactive)
  (switch-to-buffer "*eshell*")
  (end-of-buffer))

(defun eshell-pushd ()
  "Sets eshell's current directory to the pwd of current buffer."
  (interactive)
  (let ((buf-pwd default-directory))
    (message buf-pwd)
    (with-current-buffer "*eshell*"
      (eshell/pushd buf-pwd)
      (eshell-emit-prompt)
      (show-eshell))))

(add-hook 'eshell-mode-hook
          (lambda () (define-key eshell-mode-map
                       (kbd "C-c s") 'eshell-shell-at-pwd)))

(global-set-key (kbd "<f10>") 'show-eshell)
(global-set-key (kbd "M-<f10>") 'eshell-pushd)

;; eval-expression

(eval-after-load 'icicles
  '(progn (add-hook 'minibuffer-setup-hook 'conditionally-enable-smartparens-mode)
          (defun conditionally-enable-smartparens-mode ()
            "enable smartparens-mode during eval-expression"
            (if (eq this-command 'icicle-pp-eval-expression)
                (smartparens-mode 1)))
          (define-key icicle-read-expression-map [(tab)] 'hippie-expand)))

;; processing many files
;; depends on dired+

(defun on-dired-marked-files (f)
  (interactive "aFunction to call on each file: ")
  (dolist (file (diredp-get-files nil nil t t))
    (when (not (file-directory-p file))
        (find-file file)
        (funcall f))))

(add-hook 'dired-mode-hook
          (lambda () (define-key dired-mode-map
                       (kbd "C-c f") 'on-dired-marked-files)
            (define-key dired-mode-map (kbd "b") 'browse-url-of-dired-file)))
;; open dired file in browser

;; dired stuff

(define-prefix-command 'dired-subtree-key-map)
(define-key dired-mode-map (kbd "C-c ,") 'dired-subtree-key-map)
(define-key dired-subtree-key-map (kbd "i")'dired-subtree-insert)
(define-key dired-mode-map (kbd "i")'dired-subtree-insert)
(define-key dired-subtree-key-map (kbd "k")'dired-subtree-remove)
(define-key dired-subtree-key-map (kbd "r")'dired-subtree-revert)
(define-key dired-subtree-key-map (kbd "n")'dired-subtree-narrow)
(define-key dired-subtree-key-map (kbd "u")'dired-subtree-up)
(define-key dired-subtree-key-map (kbd "d")'dired-subtree-down)
(define-key dired-subtree-key-map (kbd "C-n")'dired-subtree-next-sibling)
(define-key dired-subtree-key-map (kbd "C-p")'dired-subtree-previous-sibling)
(define-key dired-subtree-key-map (kbd "C-a")'dired-subtree-beginning)
(define-key dired-subtree-key-map (kbd "C-e")'dired-subtree-end)
(define-key dired-subtree-key-map (kbd "C-SPC")'dired-subtree-mark-subtree)
(define-key dired-subtree-key-map (kbd "C-M-SPC")'dired-subtree-unmark-subtree)
(define-key dired-subtree-key-map (kbd "o")'dired-subtree-only-this-file)
(define-key dired-subtree-key-map (kbd "M-o")'dired-subtree-only-this-directory)
(define-key dired-mode-map (kbd "/ k") 'dired-filter-mode)

(define-key mc-key-map (kbd ".") 'mc/mark-all-symbols-like-this)
(define-key mc-key-map (kbd "M-.") 'mc/mark-all-symbols-like-this-in-defun)
(define-key mc-key-map (kbd ",") 'mc/mark-all-like-this-dwim)
(define-key mc-key-map (kbd "/") 'mc/mark-more-like-this-extended)
(define-key mc-key-map (kbd "s") 'mc/mark-next-symbol-like-this)

;; SLIME
(load (expand-file-name "~/quicklisp/slime-helper.el") t) ;; don't throw error if not found

;;Python lint checking
(autoload 'flycheck "flycheck-mode")
(eval-after-load 'python
  '(progn (add-hook 'python-mode-hook
                    (lambda ()
                      (flycheck-mode)
                      (smartparens-mode)
                      (ein:connect-to-default-notebook)))
          (define-key python-mode-map (kbd "C-x p") 'ein:notebooklist-open)))

(defun start-ipython-current-project (virtualenv-dir)
  (interactive
   (let ((d (read-directory-name "VirtualEnv dir: "
                                 "~/.virtualenvs/"
                                 nil
                                 t
                                 )))
     (list d)))
  (save-excursion
    (let ((buf (get-buffer-create
                (generate-new-buffer-name (file-name-nondirectory
                                           (directory-file-name (file-name-directory (magit-project-dir))))))))
      (shell buf)
      (process-send-string buf (format ". %s/bin/activate\n" virtualenv-dir))
      (process-send-string buf (format "cd %s;ipython notebook\n" (magit-project-dir)))
      ))
  ;(ein:notebooklist-open 8888)
  ;(ein:notebook-worksheet-open-next-or-first)
  )

;; ein save worksheet after running cell
(eval-after-load 'ein-multilang
  (progn (defadvice ein:cell-execute (after ein:save-worksheet-after-execute activate)
           (ein:notebook-save-notebook-command))
         (add-hook 'ein:notebook-multilang-mode-hook 'smartparens-mode)))

;; javascript
(eval-after-load 'js
  '(progn (make-variable-buffer-local 'indent-tabs-mode)
          (add-hook 'js-mode-hook (lambda ()
                                    (setq js-indent-level 8)
                                    (setq indent-tabs-mode t)))))

;;split frame either horizontally or vertically depending on screen orientation
(defun resplit-frame ()
  (interactive)
  (delete-other-windows)
  (if (> (frame-pixel-width)
         (frame-pixel-height))
      (split-window-right)
    (split-window-below)))

(global-set-key (kbd "C-c r") 'resplit-frame)
(global-set-key (kbd "C-c x f") 'find-file-in-project)

;;open dired file in associated desktop app
(defun dired-xdg-open-file ()
  "Opens the current file in a Dired buffer."
  (interactive)
  (xdg-open-file (dired-get-file-for-visit)))

(defun xdg-open-file (filename)
  "xdg-opens the specified file."
  (interactive "fFile to open: ")
  (let ((process-connection-type nil))
    (start-process "" nil "/usr/bin/xdg-open" filename)))

 ;;'e' usually does 'dired-find-file, same as RET, rebinding it here
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "e") 'dired-xdg-open-file)))

;;add option to just kill the buffer when prompted by save-some-buffers
(add-to-list 'save-some-buffers-action-alist `((?\C-k) kill-buffer ,(purecopy "kill this buffer")))

;;Go
;;set paths

(let ((mygopath "/home/jweiss/workspace/go/bin"))
  (setenv "PATH" (concat (getenv "PATH") ":" mygopath))
  (add-to-list 'exec-path mygopath))
(setenv "GOPATH" "/home/jweiss/workspace/go/")
(add-hook 'go-mode-hook
          (lambda ()
            (local-set-key (kbd "M-.") 'godef-jump)
            (local-set-key (kbd "C-c C-j") 'imenu)
            (electric-indent-mode)
            (smartparens-mode)
            ;;(setq tab-width 4)
            ;;(setq indent-tabs-mode nil)
            ))

