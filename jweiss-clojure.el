(defun tweak-clojure-syntax (mode)
  (tweak-lisp-syntax mode)
  (font-lock-add-keywords
   mode
   '(("#?\\^?{\\|}" . 'clojure-braces)
     ("\\[\\|\\]" . 'clojure-brackets)
     ("nil\\|true\\|false\\|%[1-9]?" . 'clojure-special)
     ("(\\(\\.[^ \n)]*\\|[^ \n)]+\\.\\|new\\)\\([ )\n]\\|$\\)" 1
      'clojure-java-call)
     ("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 'font-lock-warning-face t))
   ;; (("(\\(fn\\>\\)" 0 (progn (compose-region (match-beginning 1)
   ;;                                           (match-end 1) "ƒ") nil)))
   ;; (("(\\(->\\>\\)" 0 (progn (compose-region (match-beginning 1)
   ;;                                           (match-end 1) "→") nil)))
   ;; (("(\\(->>\\>\\)" 0 (progn (compose-region (match-beginning 1)
   ;;                                            (match-end 1) "↠") nil)))
   ;; (("(\\(complement\\>\\)" 0 (progn (compose-region
   ;;                                    (match-beginning 1)
   ;;                                    (match-end 1) "¬") nil)))
   ))

(defun set-clojure-colors (mode-fn)
  (tweak-clojure-syntax mode-fn)
  (set-lisp-colors mode-fn)

  (set-face-foreground 'clojure-brackets "#445f5f")
  (set-face-attribute 'clojure-brackets nil :underline nil :bold t)

  (set-face-foreground 'clojure-braces "#5f4d44")
  (set-face-attribute 'clojure-braces nil :underline nil :bold t)


  (set-face-foreground 'clojure-java-call "#ccffcc")
  (set-face-foreground 'clojure-namespace "#0000ff")
  (set-face-attribute 'clojure-namespace nil :underline nil :bold t)

  (set-face-foreground 'clojure-special "#bbbbff")
  (set-face-attribute 'clojure-special nil :underline nil :bold t :italic t))

(autoload 'clojure-mode "clojure-mode")
(autoload 'clojure-mode-map "clojure-mode" nil nil 'keymap)


(add-hook 'cider-repl-mode-hook (lambda ()
                                  (set-clojure-colors nil)
                                  (font-lock-add-keywords nil clojure-font-lock-keywords)
                                  (eldoc-mode)))

(require 'clj-refactor)
(require 'highlight-symbol)
(add-hook 'clojure-mode-hook
          (lambda ()
            (define-key clojure-mode-map (kbd "<return>") 'sp-forward-sexp)
            ;; imenu keybind
            (define-key clojure-mode-map (kbd "C-c i") 'imenu)
            ;; disable kill-sentence
            (define-key clojure-mode-map (kbd "M-k") nil)
            ;;enable clojure refactor
            (clj-refactor-mode 1)
            ;; highlight symbols
            (highlight-symbol-mode 1)
            (define-key clojure-mode-map (kbd "C-M-,") 'highlight-symbol-prev)
            (define-key clojure-mode-map (kbd "C-M-.") 'highlight-symbol-next)
            (yas-minor-mode 1)
            (set-clojure-colors nil)
            (font-lock-add-keywords nil clojure-font-lock-keywords)))

(add-hook 'inf-clojure-mode-hook
          (lambda ()
            (set-clojure-colors nil)
            (font-lock-add-keywords 'inf-clojure-mode clojure-font-lock-keywords)))
;; Define extra clojure faces
(def-mode-face clojure-braces       "#49b2c7"   "Clojure braces")
(def-mode-face clojure-brackets     "#0074e8"   "Clojure brackets")
(def-mode-face clojure-namespace    "#a9937a"   "Clojure namespace")
(def-mode-face clojure-java-call    "#7587a6"   "Clojure Java calls")
(def-mode-face clojure-special      "#0074e8"   "Clojure special")

(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; fix cider-jack-in over TRAMP the default function will return a
;; wrong path if jacking in on a tramp dir. just use lein without full
;; path and assume lein is on the PATH at the remote end.
(eval-after-load 'cider
  (defun cider--lein-resolve-command ()
    "Find `cider-lein-command' on `exec-path' if possible, or return `nil'.

In case `default-directory' is non-local we assume the command is available."
    (shell-quote-argument (or (when (file-remote-p default-directory)
                                cider-lein-command)
                              (executable-find cider-lein-command)
                              (executable-find (concat cider-lein-command ".bat"))))))
