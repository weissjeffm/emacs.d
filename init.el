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
 '(erc-modules (quote (autojoin button completion fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp track)))
 '(erc-save-buffer-on-part nil)
 '(erc-save-queries-on-quit nil)
 '(global-hl-line-mode t)
 '(ibuffer-saved-filter-groups (quote (("jeff1" ("slime" (name . "SLIME\\|slime\\|swank")) ("ERC" (mode . erc-mode)) ("katello.auto" (filename . "katello\\.auto"))) ("normal" ("Clojure" (mode . clojure-mode)) ("irc" (mode . erc-mode)) ("git" (mode . magit-mode)) ("org" (mode . org-mode)) ("emacs" (or (name . "^\\*scratch\\*$") (name . "^\\*Messages\\*$")))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(ido-default-buffer-method (quote selected-window))
 '(jabber-account-list (("jeffrey.m.weiss@gmail.com")))
 '(menu-bar-mode nil)
 '(org-agenda-files (quote ("~/tasks/7212467cf49c6e11eaff/jweiss.org")))
 '(reb-re-syntax ((lambda nil (quote string))))
 '(show-paren-style (quote expression)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white" :slant normal :weight normal :height 92 :width normal :family "DejaVu Sans Mono"))))
 '(ac-completion-face ((t (:inherit default :foreground "darkgray" :underline t))))
 '(erc-input-face ((t (:foreground "gray"))))
 '(fixed-pitch ((t (:inherit default))))
 '(hl-line ((t (:inherit highlight :background "#151500"))))
 '(magit-item-highlight ((t (:background "gray10"))))
 '(show-paren-match ((t (:background "#1a1d2e"))))
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans")))))

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(setq package-archive-exclude-alist '(("melpa" slime)))

(when (not (package-installed-p 'melpa))
  (package-refresh-contents)
  (package-install 'melpa))

;; Add in your own as you wish:
(defvar my-packages '(slime starter-kit starter-kit-lisp starter-kit-bindings clojure-mode
                            auto-complete durendal ac-slime mwe-log-commands ace-jump-mode
                            idomenu iedit haskell-mode markdown-mode)
  "A list of packages to ensure are installed at launch.")

(setq package-archive-exclude-alist '(("melpa" slime)))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;this works in some emacs setups but not others, don't know why
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

(setq package-archive-enable-alist nil)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode 1)))



(put 'narrow-to-region 'disabled nil)

