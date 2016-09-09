(deftheme jweiss2
  "Created 2015-09-08.")

(custom-theme-set-variables
 'jweiss2
 '(ac-auto-show-menu t)
 '(ac-expand-on-auto-complete nil)
 '(c-basic-offset 4)
 '(cider-annotate-completion-candidates t)
 '(cider-repl-use-clojure-font-lock t)
 '(cider-repl-use-pretty-printing nil)
 '(custom-theme-load-path (quote (quote (quote ("/home/jweiss/.emacs.d/elpa/solarized-theme-20150319.102/" custom-theme-directory t "/home/jweiss/.emacs.d/themes")))))
 '(dired-recursive-deletes (quote (quote (quote always))))
 '(flycheck-highlighting-mode (quote (quote (quote sexps))))
 '(flycheck-python-flake8-executable "~/.virtualenvs/cfme/bin/flake8")
 '(ido-default-buffer-method (quote (quote (quote selected-window))))
 '(ido-default-file-method (quote (quote (quote selected-window))))
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "sbcl"))

(custom-theme-set-faces
 'jweiss2
 '(notmuch-search-count ((t (:inherit default :foreground "light gray"))))
 '(notmuch-search-date ((t (:inherit default :foreground "cyan"))))
 '(notmuch-search-subject ((t (:inherit default :foreground "DarkSeaGreen2"))))
 '(ac-completion-face ((t (:inherit default :foreground "darkgray" :underline t))))
 '(clojure-keyword-face ((t (:inherit lisp-keyword))))
 '(secondary-selection ((t (:background "gray11"))))
 '(fixed-pitch ((t (:inherit default))))
 '(hl-line ((t (:inherit highlight :background "#151500"))))
 
 '(rcirc-timestamp ((t (:inherit default :background "black" :foreground "gray25"))))
 '(region ((t (:background "#57230c"))))
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans"))))
 '(show-paren-match ((t (:background "#292903"))))
 '(org-level-1 ((t (:foreground "white" :height 1.75 :weight bold :inherit outline-1))))
 '(org-level-2 ((t (:foreground "gray80" :height 1.5 :weight bold :inherit outline-2))))
 '(org-level-3 ((t (:foreground "gray60" :height 1.25 :weight bold :inherit outline-3))))
 '(org-level-4 ((t (:foreground "gray40" :height 1.1 :weight bold :inherit outline-4))))
 '(default ((t (:background "black" :foreground "white" :slant normal :weight normal :family "DejaVu Sans Mono")))))

(provide-theme 'jweiss2)
