;;smartparens keybindings
(require 'smartparens)
(require 'smartparens-html)
(dolist (mode '(scheme emacs-lisp lisp clojure clojurescript eshell html))
    ;; (when (> (display-color-cells) 8)
    ;;   (font-lock-add-keywords (intern (concat (symbol-name mode) "-mode"))
    ;;                           '(("(\\|)" . 'esk-paren-face))))
    (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
              'smartparens-strict-mode))
(add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)
(add-hook 'cider-mode-hook 'eldoc-mode)
(sp-pair "(" ")" :wrap "M-(")
(sp-pair "[" "]" :wrap "M-[")
(sp-pair "{" "}" :wrap "M-{")
;; no '' pair in lisp
(sp-local-pair '(emacs-lisp-mode slime-repl-mode clojure-mode lisp-interaction-mode cider-repl-mode) "'" nil :actions nil)
(sp-local-pair '(emacs-lisp-mode slime-repl-mode clojure-mode lisp-interaction-mode cider-repl-mode) "`" nil :actions nil)
(define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-backward-kill-sexp)
;; eval-expression
(eval-after-load 'icicles
  '(progn (add-hook 'minibuffer-setup-hook 'conditionally-enable-smartparens-mode)
          (defun conditionally-enable-smartparens-mode ()
            "enable smartparens-mode during eval-expression"
            (if (eq this-command 'icicle-pp-eval-expression)
                (smartparens-mode 1)))
          (define-key icicle-read-expression-map [(tab)] 'hippie-expand)))



;; focus mode - narrow to expanding or contracting sexps
(defun narrow-to-expression ()
  (interactive)
  (mark-sexp)
  (narrow-to-region (point) (mark))
  (deactivate-mark t))

(defun focus-lisp-movement (motion-fn) 
  (widen)
  (let ((pt (point)))
    (funcall motion-fn)
    (if (not (eq pt (point)))
        (narrow-to-expression))
    (deactivate-mark t)))

(defun focus-lisp-up ()
  (interactive)
  (focus-lisp-movement 'sp-backward-up-sexp))

(defun focus-lisp-down ()
  (interactive)
  (focus-lisp-movement 'sp-down-sexp))

(define-key smartparens-mode-map (kbd "C-M-S-U") 'focus-lisp-up)
(define-key smartparens-mode-map (kbd "C-M-S-D") 'focus-lisp-down)
(define-key smartparens-mode-map (kbd "C-M-u") 'sp-backward-up-sexp)
(global-set-key (kbd "C-x n e") 'narrow-to-expression)
