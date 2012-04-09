(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings clojure-mode durendal ac-slime yasnippet)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;this works in some emacs setups but not others, don'tknow why
;; (add-hook 'slime-repl-mode-hook
;;           (defun clojure-mode-slime-font-lock ()
;;             (let (font-lock-mode)
;;               (clojure-mode-font-lock-setup))))
;;this one is uglier but works
(add-hook 'slime-repl-mode-hook 
          (lambda ()
            (font-lock-mode nil)
            (clojure-mode-font-lock-setup)
            (font-lock-mode t)))


(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode 1)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-autojoin-channels-alist (quote (("freenode.net" "#emacs" "#clojure" "#katello" "#pulp") ("devel.redhat.com" "#cloud-qe" "#systemengine" "#systemengine-qe" "#candlepin"))))
 '(erc-enable-logging t)
 '(erc-generate-log-file-name-function (lambda (buffer target nick server port) (let ((file (concat (if target (concat target "@")) server ":" (cond ((stringp port) port) ((numberp port) (number-to-string port))) ".txt"))) (convert-standard-filename file))))
 '(erc-join-buffer (quote bury))
 '(erc-log-channels-directory "~/.erc/logs/")
 '(erc-log-mode t)
 '(erc-log-write-after-insert t)
 '(erc-log-write-after-send t)
 '(erc-save-buffer-on-part nil)
 '(erc-save-queries-on-quit nil)
 '(ibuffer-saved-filter-groups (quote (("normal" ("Clojure" (mode . clojure-mode)) ("irc" (mode . erc-mode)) ("git" (mode . magit-mode)) ("org" (mode . org-mode)) ("emacs" (or (name . "^\\*scratch\\*$") (name . "^\\*Messages\\*$")))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(org-agenda-files (quote ("~/tasks/7212467cf49c6e11eaff/jweiss.org"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(magit-item-highlight ((t (:background "gray10")))))

