(setq auto-save-visited-mode t)

 (setq doom-font (font-spec :family "Source Code Pro" :size 14))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))


(defun itai/org-setup ()
  "Because of autoloading org is not loaded until it's called. It causes some of the variables to not take affect 
cause org was not loaded.
with-eval-after-load can be replaced with After!. Which is a macro -> that's why I couldn't find it with spc h f "

  (with-eval-after-load 'org
    (setq org-startup-indented t
          org-bullets-bullet-list '("› ")
          org-ellipsis "  ⌄  "
          org-pretty-entities t
          org-hide-emphasis-markers t
          )))

(itai/org-setup)

;; if I want to add to doom template I have to use (add-to-list 'org-capture-templates ....
(setq org-capture-templates
      '(("t" "MUI Task" entry (file+headline "~/Dropbox/org/mui.org" "Current")
         "** %?\n ")))

(setq deft-directory "~/Dropbox/notes/")
(setq org-directory "~/Dropbox/org/")

; to allow coping/moving files to next window split
(setq dired-dwim-target t)

; TODO create a function to toggle between gutter marks for working (default) to staged
;; (custom-set-variables
;;  '(git-gutter:diff-option "--staged"))

;; change order magit sort branches
(setq magit-list-refs-sortby "-creatordate")
;; turns on wip mode to auto save working tree to git
(setq magit-wip-mode t)
;; disable escape to quit - happens too many time on accident
(map! :map magit-status-mode-map :n "escape" nil)


;; auto save org files
(add-hook 'auto-save-hook 'org-save-all-org-buffers)

; fix the weird info keyboard mapping
(map! :map Info-mode-map
      :n "l" #'evil-forward-char
      :n "h" #'evil-backward-char
      :n "C-u" #'Info-scroll-down
      :n "C-d" #'Info-scroll-up
      )

;; sets so documentation pops on the right side
(set-popup-rule! "^\\*info\\*$" :width 80 :side 'right)
(set-popup-rule! "^\\*[Hh]elp" :size 0.35)
(set-popup-rule! "^\\*Man " :width 80 :side 'right)
(set-popup-rule! "^\\*Customize" :width 80 :side 'right)

(load-theme 'doom-one-light t)
(custom-set-faces
 ;; should be replace with defface or face-remap-add-relative
 '(org-code ((t (:background "white" :foreground "gray46" :family "Fira Mono"))))
 '(org-level-1 ((t (:foreground "#444444" :weight normal :height 1.6))))
 '(org-level-2 ((t (:foreground "#444444" :weight normal :height 1.4))))
 '(org-level-3 ((t (:foreground "#444444" :weight normal :height 1.1)))))

(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(add-hook 'org-mode-hook
          (lambda ()
            (set-window-margins (selected-window) 3)
            (set-window-margins nil 3) ;;requires setting org-mode to apply everytime
            (hl-line-mode -1)
            (smartparens-mode -1) ;; nil toggles and -1 disables
            (setq indicate-empty-lines nil)
            (setq line-spacing 0.3)))
