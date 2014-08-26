(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("jweiss" . "http://qeblade5.rhq.lab.eng.bos/isos/emacs-package-archive/") t)
(package-initialize)

(when (not (package-installed-p 'melpa))
  (package-refresh-contents)
  (package-install 'melpa))

;; Add in your own as you wish:
(defvar my-packages '(clojure-mode smartparens magit find-file-in-project
                       auto-complete ac-nrepl nrepl mwe-log-commands ace-jump-mode
                       haskell-mode markdown-mode bbdb eudc
                       dired+ icicles elisp-slime-nav flycheck)
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
 '(eclim-eclipse-dirs "~/.eclipse/")
 '(eclim-executable "/home/jweiss/.eclipse/org.eclipse.platform_793567567_linux_gtk_x86_64/eclim")
 '(ein:connect-default-notebook "8888/dispatch")
 '(ein:use-auto-complete-superpack t)
 '(ein:worksheet-enable-undo (quote full))
 '(erc-autojoin-channels-alist (quote (("freenode.net" "#bitcoin" "#leiningen" "#emacs" "#clojure" "#katello" "#pulp") ("devel.redhat.com" "#cloud-qe" "#systemengine" "#systemengine-qe" "#candlepin" "#rdu16ne" "#rdu"))))
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
 '(erc-server-reconnect-timeout 60)
 '(erc-server-send-ping-timeout 30)
 '(flycheck-highlighting-mode (quote sexps))
 '(flycheck-python-flake8-executable "~/.virtualenvs/cfme/bin/flake8")
 '(flymake-python-pyflakes-executable "flake8")
 '(flymake-python-pyflakes-extra-arguments (quote ("--max-line-length=100" "--ignore=E128,E811")))
 '(global-hl-line-mode t)
 '(global-undo-tree-mode t)
 '(icicle-Completions-text-scale-decrease 0.0)
 '(icicle-TAB-completion-methods (quote (vanilla basic)))
 '(icicle-buffer-require-match-flag (quote partial-match-ok))
 '(icicle-buffer-sort (quote icicle-sort-by-last-use-as-input))
 '(icicle-completions-format (quote vertical))
 '(icicle-expand-input-to-common-match 1)
 '(icicle-incremental-completion (quote always))
 '(icicle-max-candidates 100)
 '(icicle-mode t)
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "sbcl" t)
 '(jabber-account-list (("jeffrey.m.weiss@gmail.com")))
 '(jedi:server-args (quote ("--virtual-env" "/home/jweiss/workspace/cfme_pages/cfme")))
 '(mail-signature "Jeff Weiss
Principal Quality Assurance Engineer
jweiss@redhat.com
(919)886-6533")
 '(menu-bar-mode nil)
 '(minimap-update-delay 0.3)
 '(mouse-yank-at-point t)
 '(notmuch-hello-thousands-separator ",")
 '(notmuch-saved-searches (quote (("newstuff" . "tag:new AND (folder:Redhat/INBOX OR folder:GMail/INBOX OR folder:Personal/INBOX OR folder:Redhat/Lists/katello/devel OR folder:Redhat/Lists/katello/internal)") ("announce-list" . "folder:RedHat/lists/announce-list AND tag:new"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-search-result-format (quote (("authors" . "%-28s") ("date" . "%12s ") ("count" . "%-7s ") ("subject" . "%s ") ("tags" . "(%s)"))))
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(org-agenda-files (quote ("~/workspace/cfme_tests/jweiss.org" "~/tasks/7212467cf49c6e11eaff/jweiss.org")))
 '(package-archive-upload-base "/scp:root@qeblade5.rhq.lab.eng.bos:/root/ISOs/emacs-package-archive/")
 '(python-skeleton-autoinsert t)
 '(rcirc-authinfo (quote (("irc.freenode.net" nickserv "jweiss" "111111jm") ("irc.devel.redhat.com" userserv "jweiss" "111111jm"))))
 '(rcirc-buffer-maximum-lines 2000)
 '(rcirc-default-full-name "Jeff Weiss")
 '(rcirc-default-user-name "jweiss")
 '(rcirc-fill-column (quote frame-width))
 '(rcirc-log-flag t)
 '(rcirc-notify-check-frame nil)
 '(rcirc-notify-message "%s: %s")
 '(rcirc-notify-message-private "(priv) %s: %s")
 '(rcirc-notify-timeout 30)
 '(rcirc-server-alist (quote (("irc.freenode.net" :channels ("#rcirc" "#emacs" "#clojure" "#python" "#bitcoin")) ("irc.devel.redhat.com" :channels ("#cloud-qe" "#rdu16ne" "#rdu" "#cfme-qe" "#cfme-eng" "#cloudforms") nil nil))))
 '(rcirc-track-minor-mode t)
 '(reb-re-syntax ((lambda nil (quote string))))
 '(safe-local-variable-values (quote ((eval font-lock-add-keywords nil (\` (((\, (concat "(" (regexp-opt (quote ("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl")) t) "\\_>")) 1 (quote font-lock-variable-name-face))))))))
 '(scroll-bar-mode nil)
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(smtpmail-default-smtp-server "localhost" t)
 '(smtpmail-smtp-server "localhost" t)
 '(smtpmail-smtp-service 587 t)
 '(smtpmail-smtp-user nil)
 '(smtpmail-stream-type nil)
 '(sp-base-key-bindings (quote paredit))
 '(sp-highlight-pair-overlay nil)
 '(sp-highlight-wrap-overlay nil)
 '(sp-highlight-wrap-tag-overlay nil)
 '(tool-bar-mode nil)
 '(undo-tree-auto-save-history t)
 '(undo-tree-visualizer-timestamps t)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(virtualenv-root "~/.virtualenvs/")
 '(visible-bell nil)
 '(yagist-authenticate-function (quote yagist-oauth2-authentication) t)
 '(yagist-github-token "32850b37f0394bf2e54326f66c60d73b7823f60d")
 '(yagist-github-user "weissjeffm")
 '(yagist-view-gist t)
 '(yaml-indent-offset 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white" :slant normal :weight normal :height 92 :width normal :family "DejaVu Sans Mono"))))
 '(ac-completion-face ((t (:inherit default :foreground "darkgray" :underline t))))
 '(clojure-parens ((t (:foreground "gray38" :underline nil :weight bold))))
 '(diff-added ((t (:inherit diff-changed :background "#113311" :foreground "gray70"))))
 '(diff-removed ((t (:inherit diff-changed :background "#331111" :foreground "gray70"))))
 '(ein:cell-input-area ((t nil)))
 '(erc-input-face ((t (:foreground "gray"))))
 '(fixed-pitch ((t (:inherit default))))
 '(hl-line ((t (:inherit highlight :background "#151500"))))
 '(icicle-current-candidate-highlight ((t (:background "yellow" :foreground "black"))))
 '(icicle-mode-line-help ((t (:weight bold))))
 '(magit-item-highlight ((t (:background "gray10"))))
 '(minimap-active-region-background ((t (:background "#3517205D0000"))))
 '(minimap-font-face ((t (:height 20 :family "DejaVu Sans Mono"))))
 '(notmuch-search-count ((t (:inherit default :foreground "light gray"))))
 '(notmuch-search-date ((t (:inherit default :foreground "cyan"))))
 '(notmuch-search-subject ((t (:inherit default :foreground "DarkSeaGreen2"))))
 '(rcirc-timestamp ((t (:inherit default :background "black" :foreground "gray25"))))
 '(show-paren-match ((t (:background "#1a1d2e"))))
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans")))))

(load (concat user-emacs-directory "jweiss.el"))
(load (concat user-emacs-directory "jweiss-rcirc.el"))
(load (concat user-emacs-directory "jweiss-mail.el"))

;;  '(icicle-apropos-complete-keys (quote ([9] [tab] [(control 105)])))
;;  '(icicle-prefix-complete-keys (quote ([S-tab] [S-iso-lefttab])))
;;  '(icicle-word-completion-keys (quote ([M-tab] [M-iso-lefttab] [32] " ")))
;;  '(icicle-default-cycling-mode (quote apropos))
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
