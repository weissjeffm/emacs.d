;; More syntax coloring

(setq my-lisp-font-lock-keywords
      '(("(\\|)" . 'lisp-parens)
        ("\\s-+:\\w+" . 'lisp-keyword)
        ("#?\"" 0 'double-quote prepend)))

(defun tweak-lisp-syntax (mode)
  (font-lock-add-keywords mode my-lisp-font-lock-keywords))

(defun set-lisp-colors (mode-fn)
  (tweak-lisp-syntax mode-fn)
  (set-face-foreground 'double-quote "LightSalmon")
  (set-face-foreground 'font-lock-string-face "#ffddaa")
  (set-face-foreground 'lisp-parens "gray32")
  (set-face-attribute 'lisp-parens nil :underline nil :bold t)
  (set-face-foreground 'lisp-keyword "#ffcccc")
  (set-face-attribute 'lisp-keyword nil :underline nil :bold nil :italic t)
  (set-face-foreground 'font-lock-keyword-face "#eeaaff")
  (set-face-attribute 'font-lock-keyword-face nil :underline nil :bold t :italic nil)
  (set-face-attribute 'font-lock-function-name-face nil :underline nil :bold t)
  (set-face-foreground 'font-lock-function-name-face "#ffeeaa")
  (set-face-attribute 'font-lock-builtin-face nil :underline nil :bold t)
  (set-face-foreground 'font-lock-builtin-face "#aaddff"))

(def-mode-face double-quote "#00920A"   "special")
(def-mode-face lisp-keyword      "#45b8f2"   "Lisp keywords")
(def-mode-face lisp-parens       "DimGrey"   "Lisp parens")

(set-lisp-colors 'emacs-lisp-mode)
(set-lisp-colors 'lisp-mode)

(defun slime-repl-font-lock-setup ()
  (font-lock-mode nil)
  (setq font-lock-defaults
        '((my-lisp-font-lock-keywords lisp-font-lock-keywords-2)
          ;; From lisp-mode.el
          nil nil (("+-*/.<>=!?$%_&~^:@" . "w")) nil
          (font-lock-syntactic-face-function
           . lisp-font-lock-syntactic-face-function)))
  (set-lisp-colors 'slime-repl-mode)
  (font-lock-mode t))

(add-hook 'slime-repl-mode-hook 'slime-repl-font-lock-setup)

(defadvice slime-repl-insert-prompt (after font-lock-face activate)
  (let ((inhibit-read-only t))
    (add-text-properties
     slime-repl-prompt-start-mark (point)
     '(font-lock-face
      slime-repl-prompt-face
      rear-nonsticky
      (slime-repl-prompt read-only font-lock-face intangible)))))


(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)

;; SLIME
(load (expand-file-name "~/quicklisp/slime-helper.el") t) ;; don't throw error if not found
(add-to-list 'load-path "~/.emacs.d/ac-slime-20141002.639/")


(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'smartparens-mode)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
