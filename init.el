
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("local" . "/home/jweiss/.emacs.d/package-archives"))
(package-initialize)

;; (when (not (package-installed-p 'melpa))
;;   (package-refresh-contents)
;;   (package-install "melpa"))

;; Add in your own as you wish:
(defvar my-packages '(clojure-mode smartparens magit find-file-in-project
                       auto-complete mwe-log-commands ace-jump-mode
                       haskell-mode markdown-mode bbdb eudc undo-tree
                       dired+ dired-subtree icicles elisp-slime-nav flycheck ido smex
                       multiple-cursors virtualenvwrapper rcirc-notify
                       rcirc-color ein)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq package-archive-enable-alist nil)

;;(require 'icicles)
(require 'secrets)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu t)
 '(ac-expand-on-auto-complete nil)
 '(blink-cursor-mode nil)
 '(c-basic-offset 4)
 '(cider-annotate-completion-candidates t)
 '(cider-repl-use-clojure-font-lock t)
 '(cider-repl-use-pretty-printing nil)
 '(custom-safe-themes
   (quote
    ("4d7138452614f4726f8b4ccfecc5727faf63f13c9e034b3bd6179af3c3e4ad13" "e74e4efe1cb7550569a904742c1aa9de9a799dcce74f450454efc887fae2aeb6" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(custom-theme-load-path
   (quote
    ("/home/jweiss/.emacs.d/elpa/solarized-theme-20150319.102/" custom-theme-directory t "/home/jweiss/.emacs.d/themes")))
 '(dired-recursive-deletes (quote always))
 '(ein:connect-default-notebook "8888/dispatch")
 '(ein:use-auto-complete-superpack t)
 '(ein:worksheet-enable-undo (quote full))
 '(flycheck-highlighting-mode (quote sexps))
 '(flycheck-python-flake8-executable "~/.virtualenvs/cfme/bin/flake8")
 '(flymake-python-pyflakes-executable "flake8")
 '(flymake-python-pyflakes-extra-arguments (quote ("--max-line-length=100" "--ignore=E128,E811")))
 '(global-hl-line-mode t)
 '(global-undo-tree-mode t)
 '(graphviz-dot-view-command "xdot %s")
 '(icicle-Completions-text-scale-decrease 0.0)
 '(icicle-TAB-completion-methods (quote (vanilla basic)))
 '(icicle-buffer-require-match-flag (quote partial-match-ok))
 '(icicle-buffer-sort (quote icicle-sort-by-last-use-as-input))
 '(icicle-completions-format (quote vertical))
 '(icicle-expand-input-to-common-match 1)
 '(icicle-incremental-completion (quote always))
 '(icicle-max-candidates 100)
 '(icicle-mode nil)
 '(ido-default-buffer-method (quote selected-window))
 '(ido-default-file-method (quote selected-window))
 '(imenu-auto-rescan t)
 '(indent-tabs-mode nil)
 '(inferior-lisp-program "sbcl" t)
 '(iswitchb-mode t)
 '(jabber-account-list (("jeffrey.m.weiss@gmail.com")))
 '(jedi:server-args
   (quote
    ("--virtual-env" "/home/jweiss/workspace/cfme_pages/cfme")))
 '(mail-signature nil)
 '(menu-bar-mode nil)
 '(minimap-update-delay 0.3)
 '(mouse-yank-at-point t)
 '(notmuch-crypto-process-mime t)
 '(notmuch-hello-thousands-separator ",")
 '(notmuch-saved-searches
   (quote
    ((:name "newstuff" :query "tag:new AND (folder:GMail/INBOX OR folder:Monetas/INBOX OR folder:Personal/INBOX OR folder:Personal-Remote/INBOX or folder:Cognitect/INBOX)")
     (:name "Monetas-new" :query "tag:new AND folder:Monetas/INBOX")
     (:name "cognitect-new" :query "tag:new AND folder:Cognitect/INBOX"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-search-result-format
   (quote
    (("authors" . "%-28s")
     ("date" . "%12s ")
     ("count" . "%-7s ")
     ("subject" . "%s ")
     ("tags" . "(%s)"))))
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(org-agenda-files
   (quote
    ("~/Documents/monetas.org" "~/tasks/7212467cf49c6e11eaff/jweiss.org")))
 '(org-startup-indented t)
 '(package-archive-upload-base "/home/jweiss/.emacs.d/package-archives")
 '(proced-filter (quote all))
 '(python-skeleton-autoinsert t)
 '(rcirc-buffer-maximum-lines 2000)
 '(rcirc-default-full-name "Jeff Weiss")
 '(rcirc-default-user-name "jweiss")
 '(rcirc-fill-column (quote frame-width))
 '(rcirc-log-flag t)
 '(rcirc-notify-check-frame nil)
 '(rcirc-notify-message "%s: %s")
 '(rcirc-notify-message-private "(priv) %s: %s")
 '(rcirc-notify-timeout 30)
 '(rcirc-server-alist
   (quote
    (("irc.freenode.net" :channels
      ("#rcirc" "#emacs" "#clojure" "#python" "#bitcoin" "#monetas-dev" "#opentransactions" "#go-nuts")))))
 '(rcirc-track-minor-mode t)
 '(reb-re-syntax ((lambda nil (quote string))))
 '(safe-local-variable-values
   (quote
    ((eval font-lock-add-keywords nil
           (quote
            (("(\\(dired-filter-define\\)[[:blank:]]+\\(.+\\)"
              (1
               (quote font-lock-keyword-face))
              (2
               (quote font-lock-function-name-face))))))
     (eval font-lock-add-keywords nil
           (\`
            (((\,
               (concat "("
                       (regexp-opt
                        (quote
                         ("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl"))
                        t)
                       "\\_>"))
              1
              (quote font-lock-variable-name-face))))))))
 '(scroll-bar-mode nil)
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-mode t)
 '(show-paren-priority 0)
 '(show-paren-style (quote expression))
 '(smtpmail-default-smtp-server nil)
 '(smtpmail-smtp-server "jweiss.com")
 '(smtpmail-smtp-service 25)
 '(smtpmail-smtp-user "jweiss")
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
 '(yaml-indent-offset 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans")))))

(load (concat user-emacs-directory "jweiss.el"))
(load (concat user-emacs-directory "jweiss-rcirc.el"))
(load (concat user-emacs-directory "jweiss-mail.el"))
(load (concat user-emacs-directory "jweiss-smartparens.el"))
(load (concat user-emacs-directory "jweiss-lisp.el"))
(load (concat user-emacs-directory "jweiss-clojure.el"))
(load (concat user-emacs-directory "jweiss-python.el"))

;;  '(icicle-apropos-complete-keys (quote ([9] [tab] [(control 105)])))
;;  '(icicle-prefix-complete-keys (quote ([S-tab] [S-iso-lefttab])))
;;  '(icicle-word-completion-keys (quote ([M-tab] [M-iso-lefttab] [32] " ")))
;;  '(icicle-default-cycling-mode (quote apropos))
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
