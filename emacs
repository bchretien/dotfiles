;;(server-start)

(require 'color-theme)
(color-theme-initialize)
(if window-system
    (color-theme-subtle-hacker)
  (color-theme-hober))

(add-to-list 'load-path "~/.dotfiles/.emacs.d")

;; remove the useless parts of the GUI
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; do not show the startup message
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; backup in temporary directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; no startup message or splash screen
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; show line numbers
(line-number-mode t)

;; show column number in status bar
(column-number-mode 1)

;; highlight characters after 80 columns
(setq whitespace-style '(face trailing lines-tail space-before-tab
                              space-after-tab))

;; use UTF-8 encoding
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; follow symlinks to version controlled files
(setq vc-follow-symlinks t)

;; transparently open compressed files
(auto-compression-mode t)

;; default to unified diffs
(setq diff-switches "-u -w")

;; keep things in the same window
(setq pop-up-windows nil)
(add-to-list 'same-window-buffer-names "*Help*")
(add-to-list 'same-window-buffer-names "*Apropos*")
(add-to-list 'same-window-buffer-names "*Summary*")

;; enable flyspell in C++
(add-hook 'c++-mode-hook
          (lambda ()
            (flyspell-prog-mode)
	    ))

;; auto-indent all the time
(define-key global-map (kbd "RET") 'newline-and-indent)

;; enable ido
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

;; get rid of trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; use re-builder
(require 're-builder)
(setq reb-re-syntax 'string)

;; prevent emacs from splitting windows
(setq split-height-threshold 1200)
(setq split-width-threshold 2000)
