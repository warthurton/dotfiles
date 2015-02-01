;------------------------------------------------------------------------------
(require 'cask "/usr/local/opt/cask/cask.el")
(cask-initialize)
;------------------------------------------------------------------------------
(setq
 inhibit-splash-screen t
 initial-scratch-message nil
 initial-major-mode 'org-mode
 echo-keystrokes 0.1
 use-dialog-box nil
 column-number-mode t
 line-number-mode t
 visible-bell t
 global-font-lock-mode t
 make-backup-files nil
 tab-width 2
 indent-tabs-mode nil
 indicate-empty-lines t
 x-select-enable-clipboard t
 )
;(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
;(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

; (scroll-bar-mode -1)
; (tool-bar-mode -1)
; (delete-selection-mode t)
; (transient-mark-mode t)
; (show-paren-mode t)

(prefer-coding-system 'utf-8)
(setq make-backup-files nil)
(setq help-window-select t)
(setq scroll-conservatively 5)
(global-set-key (kbd "C-x C-b") 'buffer-menu)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq default-frame-alist
      '(
	(width . 100)
	(height . 50)
	(font . "Source Code Pro-14")))

(tool-bar-mode -1)
(setq inhibit-splash-screen t)

(setq ring-bell-function 'ignore)

(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(defalias 'yes-or-no-p 'y-or-n-p)

;------------------------------------------------------------------------------
; (global-set-key (kbd "C-]") 'search-forward)
; (global-set-key (kbd "C-cb") 'balance-windows)
; (global-set-key (kbd "C-cg") 'goto-line)
; (global-set-key (kbd "s-+") 'text-scale-increase)
; (global-set-key (kbd "s--") 'text-scale-decrease)
;------------------------------------------------------------------------------
(require 'auto-complete-config)
(ac-config-default)
;------------------------------------------------------------------------------
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;------------------------------------------------------------------------------
; (add-hook 'ruby-mode-hook (lambda () (autopair-mode)))
; (add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
; (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
; (add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
; (add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
; (add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
; (add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
; (add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))
; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
; (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
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

; (if window-system
; (load-file "~/.emacs.d/vibrant-ink-theme.el")
; (load-theme 'vibrant-ink t)
;   )

;------------------------------------------------------------------------------
(setq enh-ruby-program "/usr/local/opt/rbenv/shims/rubyy")
(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))

(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

(setq enh-ruby-bounce-deep-indent t)
(setq enh-ruby-hanging-brace-indent-level 2)

(require 'cl) ; If you don't have it already

(defun* get-closest-gemfile-root (&optional (file "Gemfile"))
    "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
    (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
      (loop
       for d = default-directory then (expand-file-name ".." d)
       if (file-exists-p (expand-file-name file d))
       return d
       if (equal d root)
       return nil)))

(require 'compile)

(defun rspec-compile-file ()
  (interactive)
  (compile (format "cd %s;bundle exec rspec %s"
                   (get-closest-gemfile-root)
                   (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                   ) t))

(defun rspec-compile-on-line ()
  (interactive)
  (compile (format "cd %s;bundle exec rspec %s -l %s"
                   (get-closest-gemfile-root)
                   (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                   (line-number-at-pos)
                   ) t))

(add-hook 'enh-ruby-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c l") 'rspec-compile-on-line)
            (local-set-key (kbd "C-c k") 'rspec-compile-file)
            ))
