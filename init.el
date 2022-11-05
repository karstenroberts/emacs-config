
(require 'package)
;; packages!
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
						 ("melpa" . "http://melpa.org/packages/")))

(package-initialize)

;; set exec-path to PATH
;; (defun set-exec-path-from-shell-PATH ()
;;   ;; Set up Emacs' `exec-path' and PATH environment variable to match 
;;   ;; that used by the user's shell.
;;   ;; 
;;   ;; This is particularly useful under Mac OS X and macOS, where GUI
;;   ;; apps are not started from a shell.
;;   (interactive)
;;   (let ((path-from-shell (replace-regexp-in-string
;; 						  "[ \t\n]*$" "" (shell-command-to-string
;; 										  "$SHELL --login -c 'echo $PATH'"
;; 										  ))))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; (set-exec-path-from-shell-PATH)

(exec-path-from-shell-initialize)

;;;; My own Stuff
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)

;; Control tab to cycle windows
(global-set-key (kbd "<C-tab>") 'other-window)

;; eval and replace
(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(require 'shell-here)
(define-key (current-global-map) "\C-c!" 'shell-here)

;; Bind to key
(global-set-key (kbd "C-c e") 'eval-and-replace)

;; Inhibit the opening screen
(setq inhibit-splash-screen t)

;; Line numbers on the side
(global-linum-mode t)

;; Should remove the defult directory when opening a file 
(setq insert-default-directory nil)

;; No fascists.
(setq initial-scratch-message nil)
(setq initial-major-mode 'text-mode)

;; Allow toggling of dedicated windows
(defun toggle-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window (not (window-dedicated-p window))))
       "%s: Can't touch this!"
     "%s is up for grabs.")
   (current-buffer)))

(global-set-key (kbd "C-c t") 'toggle-window-dedicated)

;; No alarms.
(setq ring-bell-function 'ignore)

;; Set yes or no prompt to y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; When on a tab, make the cursor the tab length.
(setq-default x-stretch-cursor t)

;;Set tab width to 4
(setq-default tab-width 4)


;; Set cursor to line
(setq-default cursor-type 'bar)

;; Makes c-x, c-c, c-v, and some other normal windows stuff work
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; Makes selecting and typing/deleting work
(delete-selection-mode 1)

;; Make M-v do paste history
(define-key cua--cua-keys-keymap (kbd "M-v") 'cua-paste-pop)

;; Make page down still exist
(global-set-key (kbd "C-y") 'scroll-up-command)
(global-set-key (kbd "C-S-y") 'scroll-down-command)

;; Shows columns beside row number at the bottom
(setq column-number-mode t)

;; add pug mode
(use-package pug-mode
  :mode ("\\.pug\\'" . pug-mode)
)

(use-package multiple-cursors
  :ensure t
  :bind (("C-." . mc/mark-next-like-this)
	 ("C-," . mc/mark-previous-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)
	 ("C->" . mc/unmark-previous-like-this)
	 ("C-<" . mc/unmark-next-like-this)
	 ("M-<mouse-1>" . mc/add-cursor-on-click))
  :init
  (global-unset-key (kbd "M-<down-mouse-1>"))
  )

(use-package org
 :mode (("\\.org$" . org-mode))
 :ensure org
 :config
 (progn
   ;; config stuff
   ;; The following lines are always needed.  Choose your own keys.
   (global-set-key "\C-cl" 'org-store-link)
   (global-set-key "\C-ca" 'org-agenda)
   (global-set-key "\C-cc" 'org-capture)
   (global-set-key "\C-cb" 'org-iswitchb)
   ;; Other from 
   ))

(setq org-startup-indented t)

;; Magit
(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  )

;; Json-Mode
(use-package json-mode
  :ensure json-mode
  :config
  (setq js-indent-level 4)
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
  )

;; Stuff from Sahiil
(use-package avy
  :config
  (global-set-key (kbd "C-c C-j") 'avy-goto-word-1)
  :ensure t
  )

(use-package ivy
  :config
  (ivy-mode 1)
  (define-key ivy-minibuffer-map (kbd "C-n") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "C-p") 'ivy-previous-line)
  (define-key ivy-minibuffer-map (kbd "C-f") 'ivy-insert-current)
  (define-key ivy-minibuffer-map (kbd "C-h") 'ivy-immediate-done)
  :ensure t)

(use-package swiper
  :config
  (setq ivy-re-builders-alist
    '((t . ivy--regex-ignore-order)))
  (global-set-key (kbd "C-s") 'swiper)
  ;;advise swiper to recenter on exit
  (defun sc-swiper-recenter (&rest args)
    "recenter display after swiper"
    (recenter)
    )
  (advice-add 'swiper :after #'sc-swiper-recenter)
  :ensure t
  )

(use-package counsel
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "C-c C-y") 'counsel-yank-pop )
  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
  :ensure t
  )

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-idle-delay .01)
  (setq company-minimum-prefix-length 2)
  (define-key company-active-map (kbd "C-f")
    'company-complete-selection)
  (define-key company-active-map (kbd "C-n")
    'company-select-next)
  (define-key company-active-map (kbd "C-p")
    'company-select-previous)
  (add-hook 'python-mode-hook 'my/python-mode-hook)
  :ensure t)

;; paren
(electric-pair-mode 1) 
(show-paren-mode 1)
;; query replace
(global-set-key (kbd "M-r") 'query-replace)

;; recent files
(global-set-key (kbd "C-c r") 'recentf-open-more-files)
;; Save without asking
(global-set-key "\C-xs" 'save-buffer)
(global-set-key "\C-xc" 'compile)
(global-set-key "\C-xn" 'next-error)
(global-set-key "\C-xp" 'previous-error)


;; window resizes
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(setq scroll-conservatively 10000)


;; temp / test
(global-hl-line-mode 1)
;; (use-package monokai-theme
;;   :config
;;   (load-theme 'monokai t)
;;   :ensure t
;;   )
;; (use-package zenburn-theme
;;   :config
;;   (load-theme 'zenburn t)
;;   (set-face-background hl-line-face "gray28")
;;   :ensure t)
(load-theme 'solarized-dark t)

(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  (global-set-key (kbd "C-z") 'undo)
  (defalias 'redo 'undo-tree-redo)
  (global-set-key (kbd "C-s-z") 'undo-tree-redo)
  :diminish undo-tree-mode
  :ensure t)

(use-package recentf
  :config
  (recentf-mode 1))

(defun my-terminal-visible-bell ()
  "A friendlier visual bell effect."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil 'invert-face 'mode-line))

(setq visible-bell       nil
      ring-bell-function #'my-terminal-visible-bell)

;; no bars
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(blink-cursor-mode -1)
(menu-bar-mode -1)
(setq scroll-margin 3)
;; Show unfinished keystrokes early.
(setq echo-keystrokes 0.1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(exec-path-from-shell solarized-theme ssh-agency eldoc all-the-icons neotree prettier-js tide web-mode typescript-mode rjsx-mode pug-mode shell-here company-irony magit json-mode multiple-cursors elpy undo-tree org-plus-contrib zenburn-theme use-package package-build counsel company avy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;; JavaScript
(require 'rjsx-mode)
(require 'typescript-mode)
(require 'web-mode)
(require 'tide)
(require 'yasnippet)
(require 'prettier-js)

(setq prettier-js-args '("--tab-width" 4))

;; (defun tide-setup-hook ()
;;     (tide-setup)
;;     (eldoc-mode)
;;     (tide-hl-identifier-mode +1)
;;     (setq web-mode-enable-auto-quoting nil)
;;     (setq web-mode-markup-indent-offset 2)
;;     (setq web-mode-code-indent-offset 2)
;;     (setq web-mode-attr-indent-offset 2)
;;     (setq web-mode-attr-value-indent-offset 2)
;;     (setq lsp-eslint-server-command '("node" (concat (getenv "HOME") "/var/src/vscode-eslint/server/out/eslintServer.js") "--stdio"))
;;     (set (make-local-variable 'company-backends)
;;          '((company-tide company-files :with company-yasnippet)
;;            (company-dabbrev-code company-dabbrev))))

;; ;; hooks
;; (add-hook 'before-save-hook 'tide-format-before-save)


;; ;; use rjsx-mode for .js* files except json and use tide with rjsx
;; (add-to-list 'auto-mode-alist '("\\.js.*$" . rjsx-mode))
;; (add-to-list 'auto-mode-alist '("\\.json$" . json-mode))
;; (add-hook 'rjsx-mode-hook 'tide-setup-hook)


;; ;; web-mode extra config
;; (add-hook 'web-mode-hook 'tide-setup-hook
;;           (lambda () (pcase (file-name-extension buffer-file-name)
;;                   ("tsx" ('tide-setup-hook))
;;                   (_ (my-web-mode-hook)))))
;; (flycheck-add-mode 'typescript-tslint 'web-mode)
;; (add-hook 'web-mode-hook 'company-mode)
;; (add-hook 'web-mode-hook 'prettier-js-mode)
;; (add-hook 'web-mode-hook #'turn-on-smartparens-mode t)

;; ;; yasnippet
;; (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
;; (yas-global-mode 1)

;; ;; flycheck
;; (global-flycheck-mode)
;; (add-hook 'after-init-hook #'global-flycheck-mode)


(use-package react-snippets
  :ensure t)


(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

;; yasnippet
(yas-global-mode 1)

;; flycheck
(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; tide

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-attr-indent-offset 4)
  (setq web-mode-attr-value-indent-offset 4)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)


;; use rjsx-mode for .js* files except json and use tide with rjsx
(add-to-list 'auto-mode-alist '("\\.js.*$" . rjsx-mode))
;;(add-to-list 'auto-mode-alist '("\\.tsx.*$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))
(add-hook 'rjsx-mode-hook 'setup-tide-mode)




;; web-mode extra config
(add-hook 'web-mode-hook 'company-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)


;;(add-hook 'web-mode-hook #'turn-on-smartparens-mode t)

(defun my-web-mode-hook ()
  (setq web-mode-enable-auto-pairing nil))

(add-hook 'web-mode-hook 'my-web-mode-hook)

(defun sp-web-mode-is-code-context (id action context)
  (and (eq action 'insert)
	   not (or (get-text-property (point) 'part-side)
			   (get-text-property (point) 'block-side))))

;; (sp-local-pair 'web-mode "<" nil :when '(sp-web-mode))

(setq js-indent-level 4)
(setq typescript-indent-level 4)
(setq web-mode-block-padding 4)
(setq web-mode-style-padding 4)
(setq web-mode-script-padding 4)
(setq js2-basic-offset 4)
(setq sgml-basic-offset 4)

;; (require 'js2-mode)
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
;; (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

;; (require 'js2-refactor)
;; (require 'xref-js2)
;; (add-hook 'js2-mode-hook #'js2-refactor-mode)
;; (js2r-add-keybindings-with-prefix "C-c C-r")
;; (define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; ;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; ;; Unbind it.
;; (define-key js-mode-map (kbd "M-.") nil)

;; (add-hook 'js2-mode-hook (lambda ()
;;   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

;; File tree buffer

(require 'all-the-icons)
(require 'neotree)

(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-smart-open t)

(with-eval-after-load 'neotree
  (define-key neotree-mode-map (kbd "D") 'neotree-change-root))

;; Configure ssh agent
(require 'ssh-agency)

(provide 'init)
;;; init.el ends here
