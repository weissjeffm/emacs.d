(require 'eclim)
(require 'eclimd)
(require 'cc-mode)
(define-key eclim-mode-map (kbd "M-.") 'eclim-java-find-declaration)
(define-key java-mode-map (kbd "<down>") 'next-line)
(add-hook 'java-mode-hook 'smartparens-strict-mode)
(add-hook 'java-mode-hook 'eclim-mode)
(define-key java-mode-map (kbd "RET") 'my-electric-return)
