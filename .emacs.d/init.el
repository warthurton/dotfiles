;;------------------------------------------------------------------------------
(require 'cask "/usr/local/opt/cask/cask.el")
(cask-initialize)
;;------------------------------------------------------------------------------
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)
;;------------------------------------------------------------------------------
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;;------------------------------------------------------------------------------
(load-theme 'base16-twilight-dark t)
;;------------------------------------------------------------------------------
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))
;;------------------------------------------------------------------------------
(require 'discover)
(global-discover-mode 1)
;;------------------------------------------------------------------------------
(require 'undo-tree)
(global-undo-tree-mode 1)
;;------------------------------------------------------------------------------
;; I want this for dired-jump
(require 'dired-x)

;; I usually want to see just the file names
(require 'dired-details)
(dired-details-install)

;; Nice listing
(setq find-ls-option '("-print0 | xargs -0 ls -alhd" . ""))

;; Always copy/delete recursively
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))

;; Auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Hide some files
(setq dired-omit-files "^\\..*$\\|^\\.\\.$")
(setq dired-omit-mode t)

;; List directories first
(defun sof/dired-sort ()
  "Dired sort hook to list directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max))))
  (and (featurep 'xemacs)
       (fboundp 'dired-insert-set-properties)
       (dired-insert-set-properties (point-min) (point-max)))
  (set-buffer-modified-p nil))

(add-hook 'dired-after-readin-hook 'sof/dired-sort)

;; Automatically create missing directories when creating new files
(defun my-create-non-existent-directory ()
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
               (y-or-n-p (format "Directory `%s' does not exist! Create it?" parent-directory)))
      (make-directory parent-directory t))))
(add-to-list 'find-file-not-found-functions #'my-create-non-existent-directory)

;; Use ls from emacs
(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))
;;------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))

(require 'rbenv)
(rbenv-use-global)

(require 'flymake-ruby)
(require 'ruby-mode)
(require 'inf-ruby)
;;------------------------------------------------------------------------------
(require 'rspec-mode)
(setq rspec-use-rake-when-possible nil)
(setq compilation-scroll-output 'first-error)
;;------------------------------------------------------------------------------
;;------------------------------------------------------------------------------
;;------------------------------------------------------------------------------
;;------------------------------------------------------------------------------
;;------------------------------------------------------------------------------
(tool-bar-mode -1)

(setq
 inhibit-splash-screen t
 initial-scratch-message nil
 initial-major-mode 'org-mode
 echo-keystrokes 0.1
 use-dialog-box nil
 column-number-mode t
 line-number-mode t
 visible-bell nil
 global-font-lock-mode t
 make-backup-files nil
 tab-width 2
 indent-tabs-mode nil
 indicate-empty-lines t
 x-select-enable-clipboard t
 ns-use-srgb-colorspace t
 help-window-select t
 scroll-conservatively 5
 ring-bell-function 'ignore
 )
(setq ring-bell-function (lambda () (message "*beep*")))
(set-fringe-mode '(10 . 0))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
            `((".*" ,temporary-file-directory t)))


(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default c-basic-offset 2)
(setq css-indent-offset 2)
(setq js-indent-level 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-css-indent-offset 2)

(prefer-coding-system 'utf-8)
(global-set-key (kbd "C-x C-b") 'buffer-menu)

(setq default-frame-alist
      '(
	(width . 100)
	(height . 50)
	(font . "Source Code Pro-14")))


(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(defalias 'yes-or-no-p 'y-or-n-p)

;;------------------------------------------------------------------------------
; (global-set-key (kbd "C-]") 'search-forward)
; (global-set-key (kbd "C-cb") 'balance-windows)
; (global-set-key (kbd "C-cg") 'goto-line)
; (global-set-key (kbd "s-+") 'text-scale-increase)
; (global-set-key (kbd "s--") 'text-scale-decrease)
;;------------------------------------------------------------------------------
; (require 'auto-complete-config)
; (ac-config-default)
;;------------------------------------------------------------------------------
; (setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
; (smex-initialize)
; (global-set-key (kbd "M-x") 'smex)
; (global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;------------------------------------------------------------------------------
; (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
; (add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
; (add-hook 'markdown-mode-hook (lambda () (visual-line-mode t)))
;------------------------------------------------------------------------------
; (autoload 'color-theme-approximate-on "color-theme-approximate")
; (color-theme-approximate-on)
;------------------------------------------------------------------------------
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))
(when (not (eq window-system 'mac))
  (menu-bar-mode -1))

;------------------------------------------------------------------------------
;; (setq enh-ruby-program "/usr/local/opt/rbenv/shims/ruby")
;; (autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
;; (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
;; (add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.gemspec$" . enh-ruby-mode))
;; (add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
;; (add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))

;; (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

;; (setq enh-ruby-bounce-deep-indent t)
;; (setq enh-ruby-hanging-brace-indent-level 2)

;; (require 'cl) ; If you don't have it already

;; (defun* get-closest-gemfile-root (&optional (file "Gemfile"))
;;     "Determine the pathname of the first instance of FILE starting from the current directory towards root.
;; This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
;; of FILE in the current directory, suitable for creation"
;;     (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
;;       (loop
;;        for d = default-directory then (expand-file-name ".." d)
;;        if (file-exists-p (expand-file-name file d))
;;        return d
;;        if (equal d root)
;;        return nil)))

;; (require 'compile)

;; (defun rspec-compile-file ()
;;   (interactive)
;;   (compile (format "cd %s;bundle exec rspec %s"
;;                    (get-closest-gemfile-root)
;;                    (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
;;                    ) t))

;; (defun rspec-compile-on-line ()
;;   (interactive)
;;   (compile (format "cd %s;bundle exec rspec %s -l %s"
;;                    (get-closest-gemfile-root)
;;                    (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
;;                    (line-number-at-pos)
;;                    ) t))

;; (add-hook 'enh-ruby-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-c l") 'rspec-compile-on-line)
;;             (local-set-key (kbd "C-c k") 'rspec-compile-file)
;;             ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3328e7238e0f6d0a5e1793539dfe55c2685f24b6cdff099c9a0c185b71fbfff9" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
