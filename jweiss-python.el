;;Python lint checking
(autoload 'flycheck "flycheck-mode")
(eval-after-load 'python
  '(progn (add-hook 'python-mode-hook
                    (lambda ()
                      (flycheck-mode)
                      (smartparens-mode)
                      (ein:connect-to-default-notebook)))
          (define-key python-mode-map (kbd "C-x p") 'ein:notebooklist-open)))

;; ein save worksheet after running cell
(eval-after-load 'ein-multilang
  (progn (defadvice ein:cell-execute (after ein:save-worksheet-after-execute activate)
           (ein:notebook-save-notebook-command))
         (add-hook 'ein:notebook-multilang-mode-hook 'smartparens-mode)))

(defun virtualenv-shell (virtualenv-dir &optional buffer-name-append)
  (interactive (list (read-directory-name "VirtualEnv dir: " "~/.virtualenvs/" nil t) nil))
  (save-excursion
    (let* ((virtualenv-name (file-name-nondirectory (directory-file-name virtualenv-dir)))
          (buf (get-buffer-create
                (generate-new-buffer-name (concat "*" virtualenv-name buffer-name-append " virtualenv shell*")))))
      (shell buf)
      (process-send-string buf (format ". %s/bin/activate\n" virtualenv-dir))
      buf)))

(defun start-ipython-current-project (virtualenv-dir)
  (interactive (list (read-directory-name "VirtualEnv dir: " "~/.virtualenvs/" nil t)))
  (let ((buf (virtualenv-shell virtualenv-dir " ipython")))
    (process-send-string buf (format "cd %s;ipython3 notebook\n" (magit-project-dir)))))

;; virtualenvs
(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(venv-initialize-eshell) ;; if you want eshell support
(setq venv-location "~/.virtualenvs")
