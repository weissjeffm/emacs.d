;;time loading of this file
;(require 'cl) ; a rare necessary use of REQUIRE


;;disable suspending emacs on ctrl-z
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-z"))
;jump to line
(global-set-key (kbd "C-c M-l") 'goto-line)
;buffer switch 
;(global-set-key (kbd "C-,") 'ido-switch-buffer)
;;frame-switch
;(global-set-key (kbd "C-q") 'windmove-up)
;(global-set-key (kbd "C-z") 'windmove-down)
;;use ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;use w tiling window mgr
;(setq pop-up-frames nil)

;;associate some file extensions with modes
;(add-to-list 'auto-mode-alist '("\\.*repo$" . conf-unix-mode))

;;basic colors
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



(autoload 'clojure-mode "clojure-mode")
;(set-clojure-colors 'clojure-mode)
;(set-clojure-colors 'slime-repl-mode)

;(add-hook 'clojure-mode-hook 'durendal-enable-auto-compile)
(add-hook 'slime-repl-mode-hook 'durendal-slime-repl-paredit)

(add-hook 'sldb-mode-hook 'durendal-dim-sldb-font-lock)
;(add-hook 'slime-compilation-finished-hook 'durendal-hide-successful-compile)

(add-hook 'clojure-mode-hook 
          (lambda () 
            (define-key clojure-mode-map (kbd "M-[") 'paredit-wrap-square)
            (define-key clojure-mode-map (kbd "M-{") 'paredit-wrap-curly)))
;(eval-after-load 'clojure-mode (yas/reload-all))

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

