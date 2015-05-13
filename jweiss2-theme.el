(deftheme jweiss2
  "Created 2015-03-26.")

(custom-theme-set-variables
 'jweiss2
 '(ac-auto-show-menu t)
 '(ac-expand-on-auto-complete nil)
 '(c-basic-offset 4)
 '(cider-annotate-completion-candidates t)
 '(cider-repl-use-clojure-font-lock t)
 '(cider-repl-use-pretty-printing nil)
 '(custom-safe-themes (quote ("4d7138452614f4726f8b4ccfecc5727faf63f13c9e034b3bd6179af3c3e4ad13" "e74e4efe1cb7550569a904742c1aa9de9a799dcce74f450454efc887fae2aeb6" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(custom-theme-load-path (quote ("/home/jweiss/.emacs.d/elpa/solarized-theme-20150319.102/" custom-theme-directory t "/home/jweiss/.emacs.d/themes")))
 '(dired-recursive-deletes (quote always))
 '(ein:connect-default-notebook "8888/dispatch")
 '(ein:use-auto-complete-superpack t)
 '(ein:worksheet-enable-undo (quote full))
 '(flycheck-highlighting-mode (quote sexps))
 '(flycheck-python-flake8-executable "~/.virtualenvs/cfme/bin/flake8")
 '(ido-default-buffer-method (quote selected-window))
 '(ido-default-file-method (quote selected-window))
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "sbcl"))

(custom-theme-set-faces
 'jweiss2
 '(notmuch-search-count ((t (:inherit default :foreground "light gray"))))     
 '(notmuch-search-date ((t (:inherit default :foreground "cyan"))))            
 '(notmuch-search-subject ((t (:inherit default :foreground "DarkSeaGreen2"))))
 '(default ((t (:background "black" :foreground "white" :slant normal :weight normal :family "DejaVu Sans Mono"))))
 '(ac-completion-face ((t (:inherit default :foreground "darkgray" :underline t))))
 '(clojure-keyword-face ((t (:inherit lisp-keyword))))
 '(ein:cell-input-area ((t nil)))
 '(secondary-selection ((t (:background "gray11"))))
 '(fixed-pitch ((t (:inherit default))))
 '(hl-line ((t (:inherit highlight :background "#151500"))))
 '(iswitchb-current-match ((t (:inherit font-lock-function-name-face :foreground "orange red"))))
 '(rcirc-timestamp ((t (:inherit default :background "black" :foreground "gray25"))))
 '(region ((t (:background "#57230c"))))
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans"))))
 '(show-paren-match ((t (:background "#292903")))))

(provide-theme 'jweiss2)
