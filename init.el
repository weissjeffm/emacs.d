(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu t)
 '(ac-expand-on-auto-complete nil)
 '(erc-autojoin-channels-alist (quote (("freenode.net" "#leiningen" "#emacs" "#clojure" "#katello" "#pulp") ("devel.redhat.com" "#cloud-qe" "#systemengine" "#systemengine-qe" "#candlepin"))))
 '(erc-enable-logging t)
 '(erc-fill-column 100)
 '(erc-generate-log-file-name-function (lambda (buffer target nick server port) (let ((file (concat (if target (concat target "@")) server ":" (cond ((stringp port) port) ((numberp port) (number-to-string port))) ".txt"))) (convert-standard-filename file))))
 '(erc-join-buffer (quote bury))
 '(erc-log-channels-directory "~/.erc/logs/")
 '(erc-log-mode t)
 '(erc-log-write-after-insert t)
 '(erc-log-write-after-send t)
 '(erc-modules (quote (autojoin button completion fill irccontrols list log match menu move-to-prompt netsplit networks noncommands readonly ring stamp track)))
 '(erc-save-buffer-on-part nil)
 '(erc-save-queries-on-quit nil)
 '(erc-server-reconnect-attempts t)
 '(erc-server-reconnect-timeout 5)
 '(erc-server-send-ping-timeout 30)
 '(global-hl-line-mode t)
 '(ibuffer-saved-filter-groups (quote (("jeff1" ("slime" (name . "SLIME\\|slime\\|swank")) ("ERC" (mode . erc-mode)) ("katello.auto" (filename . "katello\\.auto"))) ("normal" ("Clojure" (mode . clojure-mode)) ("irc" (mode . erc-mode)) ("git" (mode . magit-mode)) ("org" (mode . org-mode)) ("emacs" (or (name . "^\\*scratch\\*$") (name . "^\\*Messages\\*$")))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(icicle-apropos-complete-keys (quote ([9] [tab] [(control 105)])))
 '(icicle-expand-input-to-common-match 2)
 '(icicle-incremental-completion (quote always))
 '(icicle-prefix-complete-keys (quote ([S-tab] [S-iso-lefttab])))
 '(ido-default-buffer-method (quote selected-window))
 '(ido-ubiquitous-enable-compatibility nil)
 '(jabber-account-list (("jeffrey.m.weiss@gmail.com")))
 '(menu-bar-mode nil)
 '(notmuch-hello-thousands-separator ",")
 '(notmuch-saved-searches (quote (("newstuff" . "tag:new AND (folder:Redhat/INBOX OR folder:GMail/INBOX OR folder:Redhat/Lists/katello/devel)") ("announce-list" . "folder:RedHat/lists/announce-list AND tag:new"))))
 '(notmuch-search-oldest-first nil)
 '(org-agenda-files (quote ("~/tasks/7212467cf49c6e11eaff/jweiss.org")))
 '(reb-re-syntax ((lambda nil (quote string))))
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-style (quote expression))
 '(smtpmail-smtp-server "smtp.corp.redhat.com")
 '(smtpmail-smtp-service 25))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white" :slant normal :weight normal :height 92 :width normal :family "DejaVu Sans Mono"))))
 '(ac-completion-face ((t (:inherit default :foreground "darkgray" :underline t))))
 '(clojure-parens ((t (:foreground "gray38" :underline nil :weight bold))))
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
(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings clojure-mode
                                  auto-complete ac-nrepl nrepl mwe-log-commands ace-jump-mode
                                  idomenu iedit haskell-mode markdown-mode bbdb eudc
                                  dired+ icicles iedit)
  "A list of packages to ensure are installed at launch.")

(setq package-archive-exclude-alist '(("melpa" slime)))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq package-archive-enable-alist nil)

(put 'narrow-to-region 'disabled nil)

