(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not (package-installed-p 'melpa))
  (package-refresh-contents)
  (package-install 'melpa))

;; Add in your own as you wish:
(defvar my-packages '( clojure-mode paredit magit find-file-in-project
                       auto-complete ac-nrepl nrepl mwe-log-commands ace-jump-mode
                       iedit haskell-mode markdown-mode bbdb eudc
                       dired+ icicles iedit elisp-slime-nav)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq package-archive-enable-alist nil)

(require 'icicles)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu t)
 '(ac-expand-on-auto-complete nil)
 '(blink-cursor-mode nil)
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
 '(icicle-Completions-text-scale-decrease 0.0)
 '(icicle-buffer-require-match-flag (quote partial-match-ok))
 '(icicle-completions-format (quote vertical))
 '(icicle-expand-input-to-common-match 1)
 '(icicle-incremental-completion (quote always))
 '(icicle-max-candidates 100)
 '(icicle-mode t)
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(jabber-account-list (("jeffrey.m.weiss@gmail.com")))
 '(menu-bar-mode nil)
 '(notmuch-hello-thousands-separator ",")
 '(notmuch-saved-searches (quote (("newstuff" . "tag:new AND (folder:Redhat/INBOX OR folder:GMail/INBOX OR folder:Redhat/Lists/katello/devel)") ("announce-list" . "folder:RedHat/lists/announce-list AND tag:new"))))
 '(notmuch-search-oldest-first nil)
 '(org-agenda-files (quote ("~/tasks/7212467cf49c6e11eaff/jweiss.org")))
 '(reb-re-syntax ((lambda nil (quote string))))
 '(scroll-bar-mode nil)
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(smtpmail-smtp-server "smtp.corp.redhat.com" t)
 '(smtpmail-smtp-service 25 t)
 '(tool-bar-mode nil)
 '(visible-bell t)
 '(yagist-authenticate-function (quote yagist-oauth2-authentication))
 '(yagist-github-token "32850b37f0394bf2e54326f66c60d73b7823f60d")
 '(yagist-github-user "weissjeffm")
 '(yagist-view-gist t))

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
 '(icicle-current-candidate-highlight ((t (:background "yellow" :foreground "black"))))
 '(magit-item-highlight ((t (:background "gray10"))))
 '(show-paren-match ((t (:background "#1a1d2e"))))
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans")))))

(load (concat user-emacs-directory "jweiss.el"))
(load (concat user-emacs-directory "jweiss-erc.el"))
(load (concat user-emacs-directory "jweiss-mail.el"))

;;  '(icicle-apropos-complete-keys (quote ([9] [tab] [(control 105)])))
;;  '(icicle-prefix-complete-keys (quote ([S-tab] [S-iso-lefttab])))
;;  '(icicle-word-completion-keys (quote ([M-tab] [M-iso-lefttab] [32] " ")))
;;  '(icicle-default-cycling-mode (quote apropos))
