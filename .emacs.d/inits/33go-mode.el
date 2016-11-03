;; go-mode
(setenv "GOPATH" "/home/masa")
(add-to-list 'exec-path (expand-file-name "~/bin"))

(with-eval-after-load 'go-mode
  ;; auto-complete
  (require 'go-autocomplete)

  ;; company-mode
  ;(add-to-list 'company-backends 'company-go)

  ;; eldoc
  (add-hook 'go-mode-hook 'go-eldoc-setup)

  (add-hook 'before-save-hook 'gofmt-before-save)
  
  ;; key bindings
  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  (define-key go-mode-map (kbd "M-,") 'pop-tag-mark))
