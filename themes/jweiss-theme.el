(deftheme jweiss
  "Created 2015-03-26.")

(custom-theme-set-faces
 'jweiss
 '(ac-completion-face ((t (:inherit default :foreground "darkgray" :underline t))))
 '(clojure-keyword-face ((t (:inherit lisp-keyword))))
 '(diff-added ((t (:inherit diff-changed :background "#113311" :foreground "gray70"))))
 '(diff-removed ((t (:inherit diff-changed :background "#331111" :foreground "gray70"))))
 '(ein:cell-input-area ((t nil)))
 '(fixed-pitch ((t (:inherit default))))
 '(hl-line ((t (:inherit highlight :background "#151500"))))
 '(magit-item-highlight ((t (:background "gray10"))))
 '(notmuch-search-count ((t (:inherit default :foreground "light gray"))))
 '(notmuch-search-date ((t (:inherit default :foreground "cyan"))))
 '(notmuch-search-subject ((t (:inherit default :foreground "DarkSeaGreen2"))))
 '(rcirc-timestamp ((t (:inherit default :background "black" :foreground "gray25"))))
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans"))))
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "#d1ccbe" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(show-paren-match ((t (:background "#303005"))))
 '(region ((t (:background "#57230c"))))
 '(double-quote ((t (:foreground "LightSalmon" :weight bold))))
 '(lisp-keyword ((t (:weight normal :slant italic :underline nil :foreground "#ffcccc"))))
 '(lisp-parens ((t (:weight bold :underline nil :foreground "gray32"))))
 '(clojure-java-call ((t (:foreground "#ccffcc"))))
 '(clojure-special ((((class color)) (:foreground "#0074e8"))))
 '(show-paren-match ((t (:inherit highlight :background "#292903")))))

(provide-theme 'jweiss)
