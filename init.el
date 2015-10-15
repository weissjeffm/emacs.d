(load-theme 'jweiss2 t)
(require 'package)
(require 'cl)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org"       . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("local" . "/home/jweiss/.emacs.d/package-archives"))
(package-initialize)

;; (when (not (package-installed-p 'melpa))
;;   (package-refresh-contents)
;;   (package-install "melpa"))

;; Add in your own as you wish:

(setq my-packages-alist
      '((lisp
         clojure-mode clojure-mode-extra-font-locking cider ac-cider smartparens elisp-slime-nav flycheck-clojure)

        (golang
         go-mode go-autocomplete go-eldoc go-errcheck flymake-go)

        (ide
         auto-complete magit find-file-in-project flycheck)

        (formats
         adoc-mode markdown-mode)

        (languages
         haskell-mode clang-format ggtags)

        (irc
         rcirc-notify rcirc-color)

        (navigating
         dired+ dired-subtree ace-jump-mode)
        
        (python
         ein virtualenvwrapper)
        
        (editing
         undo-tree multiple-cursors wgrep)
        
        (other
         mwe-log-commands gist)
        
        (email
         bbdb eudc)
        
        (completion
         icicles ido smex)
        ))

(defvar my-packages (mapcan 'cdr (copy-tree my-packages-alist)) ; copy because mapcan modifies in-place
  
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
 '(clojure-defun-indents (quote (expecting)))
 '(clojure-docstring-fill-column 79)
 '(clojure-docstring-fill-prefix-width 3)
 '(custom-safe-themes
   (quote
    ("3ad26136c15ec0da8e22cc01b8e1a07aff009eac5c550309dd886bdbae414a65" "79d9e31ba98aae3a35f18adff4b825f4695b5a5d919b8038c9d26ab330618d91" "faab0220334aec9b69074942b938a5648fa3fd5c82d5c4e41fb8cce600caf029" "45097d951e8ec98af5eb77818f3282f442f598b7907bec2481e01d53e2e71885" "f7431aef22ca157349e97d128372869db4ee82ce1c370e77b7619dae65110d35" "153155dc0f5464053145d48cf5b6c2e4348663d7f9183ddd22eae16eb2b6cbd8" "c5ee6f4310f0dff079f457b3a0d94f6b112d24e47987b090a96457ce5279d53d" "4d7138452614f4726f8b4ccfecc5727faf63f13c9e034b3bd6179af3c3e4ad13" "e74e4efe1cb7550569a904742c1aa9de9a799dcce74f450454efc887fae2aeb6" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(custom-theme-load-path
   (quote
    ("/home/jweiss/.emacs.d/elpa/solarized-theme-20150319.102/" custom-theme-directory t "/home/jweiss/.emacs.d/themes")))
 '(dired-recursive-deletes (quote always))
 '(eclim-executable "/home/jweiss/bin/eclim")
 '(eclimd-executable "/home/jweiss/bin/eclimd")
 '(ein:connect-default-notebook "8888/dispatch")
 '(ein:use-auto-complete-superpack t)
 '(ein:worksheet-enable-undo (quote full))
 '(flycheck-highlighting-mode (quote sexps))
 '(flycheck-python-flake8-executable "~/.virtualenvs/cfme/bin/flake8")
 '(flymake-python-pyflakes-executable "flake8")
 '(flymake-python-pyflakes-extra-arguments (quote ("--max-line-length=100" "--ignore=E128,E811")))
 '(global-hl-line-mode t)
 '(global-undo-tree-mode t)
 '(gofmt-command
   "GOPATH=/home/jweiss/gotary-vendored-gopath:/home/jweiss/workspace/go/ goimports")
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
 '(magit-revert-buffers (quote silent))
 '(magit-save-repository-buffers nil)
 '(mail-signature nil)
 '(menu-bar-mode nil)
 '(minimap-update-delay 0.3)
 '(mouse-yank-at-point t)
 '(notmuch-crypto-process-mime t)
 '(notmuch-hello-thousands-separator ",")
 '(notmuch-saved-searches
   (quote
    ((:name "Inbox" :query "tag:new AND (folder:GMail/INBOX OR folder:Monetas/INBOX OR folder:Personal/INBOX OR folder:Personal-Remote/INBOX or folder:Cognitect/INBOX folder:LookingGlass/INBOX)")
     (:name "Monetas" :query "tag:new AND folder:Monetas/INBOX")
     (:name "cognitect" :query "tag:new AND folder:Cognitect/INBOX")
     (:name "LG" :query "tag:new AND folder:LookingGlass/INBOX"))))
 '(notmuch-search-oldest-first nil)
 '(notmuch-search-result-format
   (quote
    (("authors" . "%-120s ")
     ("subject" . "
%s ")
     ("tags" . "(%s) ")
     ("date" . "%s ")
     ("count" . "%s
__________"))))
 '(notmuch-show-all-multipart/alternative-parts nil)
 '(org-agenda-files
   (quote
    ("~/Documents/monetas/monetas.org" "~/tasks/7212467cf49c6e11eaff/jweiss.org")))
 '(org-babel-load-languages (quote ((emacs-lisp . t) (shell . t))))
 '(org-bullets-bullet-list (quote ("●" "◉" "○" "★")))
 '(org-startup-indented t)
 '(package-archive-upload-base "/home/jweiss/.emacs.d/package-archives")
 '(powerline-default-separator (quote arrow-fade))
 '(proced-filter (quote all))
 '(python-skeleton-autoinsert t)
 '(rcirc-buffer-maximum-lines 2000)
 '(rcirc-default-full-name "Jeff Weiss")
 '(rcirc-default-user-name "jweiss")
 '(rcirc-fill-column (quote frame-width))
 '(rcirc-keywords (quote ("goats!")))
 '(rcirc-log-flag t)
 '(rcirc-notify-check-frame nil)
 '(rcirc-notify-message "%s: %s")
 '(rcirc-notify-message-private "(priv) %s: %s")
 '(rcirc-notify-timeout 30)
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
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(smtpmail-default-smtp-server nil)
 '(smtpmail-smtp-server "jweiss.com")
 '(smtpmail-smtp-service 587)
 '(smtpmail-smtp-user "jweiss")
 '(smtpmail-stream-type (quote starttls))
 '(sp-base-key-bindings (quote paredit))
 '(sp-highlight-pair-overlay nil)
 '(sp-highlight-wrap-overlay nil)
 '(sp-highlight-wrap-tag-overlay nil)
 '(tool-bar-mode nil)
 '(tramp-default-proxies-alist (quote (("192.168.66" "root" "/ssh:%h:"))))
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
 '(diff-added ((t (:inherit diff-changed :background "#112211" :foreground "green2"))))
 '(diff-removed ((t (:inherit diff-changed :background "#221111" :foreground "red1"))))
 '(notmuch-search-subject ((t (:inherit default :foreground "DarkSeaGreen2" :height 1.2))))
 '(powerline-active1 ((t (:inherit mode-line :background "grey50"))))
 '(powerline-active2 ((t (:inherit mode-line :background "grey80"))))
 '(variable-pitch ((t (:inherit default :family "DejaVu Sans")))))

(load (concat user-emacs-directory "jweiss.el"))
(load (concat user-emacs-directory "jweiss-rcirc.el"))
(load (concat user-emacs-directory "jweiss-mail.el"))
(load (concat user-emacs-directory "jweiss-smartparens.el"))
(load (concat user-emacs-directory "jweiss-lisp.el"))
(load (concat user-emacs-directory "jweiss-clojure.el"))
(load (concat user-emacs-directory "jweiss-python.el"))
(load (concat user-emacs-directory "jweiss-java.el"))

;;  '(icicle-apropos-complete-keys (quote ([9] [tab] [(control 105)])))
;;  '(icicle-prefix-complete-keys (quote ([S-tab] [S-iso-lefttab])))
;;  '(icicle-word-completion-keys (quote ([M-tab] [M-iso-lefttab] [32] " ")))
;;  '(icicle-default-cycling-mode (quote apropos))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-region 'disabled nil)
