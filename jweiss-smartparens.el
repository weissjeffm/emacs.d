;;smartparens keybindings
(require 'smartparens)

(dolist (mode '(scheme emacs-lisp lisp clojure clojurescript eshell))
    ;; (when (> (display-color-cells) 8)
    ;;   (font-lock-add-keywords (intern (concat (symbol-name mode) "-mode"))
    ;;                           '(("(\\|)" . 'esk-paren-face))))
    (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
              'smartparens-mode))
(add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)
(add-hook 'cider-mode-hook 'eldoc-mode)
(sp-pair "(" ")" :wrap "M-(")
(sp-pair "[" "]" :wrap "M-[")
(sp-pair "{" "}" :wrap "M-{")
;; no '' pair in lisp
(sp-local-pair '(emacs-lisp-mode slime-repl-mode clojure-mode lisp-interaction-mode cider-repl-mode) "'" nil :actions nil)

;; eval-expression
(eval-after-load 'icicles
  '(progn (add-hook 'minibuffer-setup-hook 'conditionally-enable-smartparens-mode)
          (defun conditionally-enable-smartparens-mode ()
            "enable smartparens-mode during eval-expression"
            (if (eq this-command 'icicle-pp-eval-expression)
                (smartparens-mode 1)))
          (define-key icicle-read-expression-map [(tab)] 'hippie-expand)))
