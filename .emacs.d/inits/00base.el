;; Save the file specified code with basic utf-8 if it exists
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)


;; exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))


;; Reduce GC to speed up (eat memory)
(setq gc-cons-threshold (* 128 1024 1024))


;;; Faster rendering by not corresponding to right-to-left language
(setq-default bidi-display-reordering nil)


;; font
;;(add-to-list 'default-frame-alist '(font . "Ricty-15.5"))
;;(add-to-list 'default-frame-alist '(font . "MyricaM-15.5"))
(add-to-list 'default-frame-alist '(font . "Cica-15.5"))


;; defalias list
(defalias 'my/keybind 'describe-personal-keybindings)
(defalias 'my/github 'browse-at-remote)


;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))


;; Do not make a backup file like *.~
(setq make-backup-files nil)
;; Do not use auto save
(setq auto-save-default nil)
;; Do not create lock file
(setq create-lockfiles nil)


;; C-h is backspace
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; Run C-x C-k same kill-buffer as C-x k
(require 'bind-key)
(bind-key "C-x C-k" 'kill-buffer)


;; switch-to-buffer
(bind-key "M-o" 'iflipb-next-buffer)
(bind-key "M-O" 'iflipb-previous-buffer)

;; minibuffer-local-completion-mpa
(bind-key "C-w" 'backward-kill-word minibuffer-local-completion-map)

;; When the mouse cursor is close to the text cursor, the mouse hangs away
(if (display-mouse-p) (mouse-avoidance-mode 'exile))

;; Disable automatic save
(setq auto-save-default nil)

;; Display file name in title bar
(setq frame-title-format (format "Emacs@%s : %%f" (system-name)))

;; Do not distinguish uppercase and lowercase letters on completion
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; Make it easy to see when it is the same name file
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Display the character position of the cursor
(column-number-mode t)

;; Increase history count
(setq history-length 10000)

;; Save history of minibuffer
(savehist-mode 1)

;; Make "yes or no" "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; Turn off warning sound screen flash
(setq visible-bell nil)
;; All warning sounds and flash are invalid (note that the warning sound does not sound completely)
(setq ring-bell-function 'ignore)

;; It keeps going steadily past the mark ...C-x C-SPC C-SPC
;; It keeps going steadily past the mark ...C-u C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; Use the X11 clipboard
(setq select-enable-clipboard  t)
(bind-key "M-w" 'clipboard-kill-ring-save)
(bind-key "C-w" 'clipboard-kill-region)


;; Brace the corresponding parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)


;; Dired files deleted by trash
(setq delete-by-moving-to-trash t)


;; Continue hitting C-SPC and go back to past marks ...C-u C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; Read elisp function source file
(bind-key "C-x F" 'find-function)
(bind-key "C-x V" 'find-variable)
;; emacs c source dir:
(setq find-function-C-source-directory "~/Dropbox/emacs/emacs-25.3/src")


;; Do not change the position of the cursor on the screen as much as possible when scrolling pages
(setq scroll-preserve-screen-position t)


;; contain many mode setting
(require 'generic-x)


;; mytimer
(defun my/timer(n)
  (interactive "nMinute:")
  (run-at-time (* n 60) nil #'_mytimer))
(defun _mytimer()
  (shell-command-to-string "notify-send -u critical 'Emacs' 'It is time' -i utilities-terminal"))


(defun my/copy-path ()
  (interactive)
  (if buffer-file-name
      (progn
	(kill-new (file-truename buffer-file-name))
	(message (buffer-file-name)))
    (progn
      (kill-new default-directory)
      (message default-directory))))


;; M-x info-emacs-manual(C-h r)
(add-to-list 'Info-directory-list "~/.emacs.d/info/")
(defun Info-find-node--info-ja (orig-fn filename &rest args)
  (apply orig-fn
         (pcase filename
           ("emacs" "emacs251-ja")
           (_ filename))
         args))
(advice-add 'Info-find-node :around 'Info-find-node--info-ja)


;; If the region is active, kill region
;; If the region is inactive, delete the previous word
(defun kill-region-or-backward-kill-word ()
  (interactive)
  (if (region-active-p)
      (clipboard-kill-region (point) (mark))
    (backward-kill-word 1)))
(bind-key "C-w" 'kill-region-or-backward-kill-word)