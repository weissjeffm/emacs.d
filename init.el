(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings clojure-mode)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-hook 'slime-repl-mode-hook (lambda ()
                                   (font-lock-mode nil)
                                   (clojure-mode-font-lock-setup)
                                   (font-lock-mode t)))
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode 1)))

