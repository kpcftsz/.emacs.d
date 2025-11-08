;;
;; KP's Emacs config
;; ----------------- 
;; I'm not the best at Elisp, and a lot of stuff here probably makes 0
;; sense, but I find this is what works best for me :)
;;

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Makes emacs startup faster
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
		gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)

;; Go away GUI (if we are not in a desktop environment)
;; I don't really even use the toolbar anyways but I like how fried the old icons look
(unless (display-graphic-p)
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Hide scrollbar in the minibuffer
(defun update-scroll-bars ()
  (interactive)
  (set-window-scroll-bars (minibuffer-window) nil nil)
  )
(add-hook 'window-configuration-change-hook 'update-scroll-bars)
(add-hook 'buffer-list-update-hook 'update-scroll-bars)

;; Better title bar
(setq-default frame-title-format '("%b - Emacs"))

;; It's not 1985, sentences end in one space
(setq-default sentence-end-double-space 'nil)

;; More expected behaviour
(setq-default delete-selection-mode 1)

;; y for yes
(fset 'yes-or-no-p 'y-or-n-p)

;; Backspace is backspace in isearch, not previous word
(define-key isearch-mode-map (kbd "<backspace>") 'isearch-del-char)
(add-hook 'isearch-mode-hook (lambda () (interactive)
							   (setq isearch-message (concat isearch-message "[ " (car search-ring) " ] "))
							   (isearch-search-and-update)))

;; Backups/autosave
(setq make-backup-files nil) ; stop creating ~ files
(setq auto-save-default nil) ; stop creating #auto-save# files

;; Tab bs (C)
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'nil)
(add-hook 'cc-mode-hook
          (lambda ()
            (c-set-offset 'arglist-intro '+)
            (c-set-offset 'arglist-close 0)))

;; Display line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; Rebind ^Z so I don't send emacs to the bg. Force of habit coming from JOE.
(global-set-key (kbd "C-z") 'ignore)

;; Allows me to "lock" buffers
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

(global-set-key (kbd "C-c l") 'toggle-window-dedicated)

;; Load Elisp files
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))

;; Cute splash screen
(defun always-use-fancy-splash-screens-p () 1)
(defalias 'use-fancy-splash-screens-p 'always-use-fancy-splash-screens-p)
(require 'random-splash-image)
(setq random-splash-image-dir "~/.emacs.d/images")
(random-splash-image-set)

;; Visual stuff
(load-theme 'KPStandard t)
(defun setup-font-faces () 
  (set-frame-font "Bitstream Vera Sans Mono")
  (set-face-attribute 'variable-pitch
					  nil
					  :family "Tahoma")
  )
(setup-font-faces)
;; re-run this hook if we create a new frame from daemonized Emacs
(add-hook 'server-after-make-frame-hook 'setup-font-faces)

;; Make Perl not feel like shit
(defalias 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cperl-array-face ((t (:weight normal))))
 '(cperl-hash-face ((t (:weight normal))))
 '(mode-line-inactive ((t (:background "#121212" :foreground "#aaaaaa" :box (:line-width (1 . 1) :color "dim gray" :style flat-button) :weight normal))))
 '(tab-bar-tab ((t (:inherit tab-bar :background "SystemButtonFace" :box (:line-width (1 . 1) :style flat-button)))))
 '(tab-line ((t (:inherit variable-pitch :background "grey15" :foreground "black" :height 1.0))))
 '(tab-line-highlight ((t (:background "grey50" :foreground "white" :box (:line-width (6 . 4) :style flat-button)))))
 '(tab-line-tab ((t (:inherit tab-line :background "gray20" :foreground "gray65" :box (:line-width (6 . 4) :style flat-button)))))
 '(tab-line-tab-current ((t (:inherit tab-line-tab :background "black" :foreground "white"))))
 '(tab-line-tab-inactive ((t (:inherit tab-line-tab :background "grey30"))))
 '(tab-line-tab-inactive-alternate ((t (:inherit tab-line-tab-inactive :background "grey55"))))
 '(tool-bar ((t (:background "gray30" :foreground "gray75"))))
 '(vertical-border ((t (:foreground "gray35")))))

;; Zen coding & better support for webshitter langs
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.edge?\\'" . web-mode))
(require 'emmet-mode)
(defun my-web-mode-hook() "Hooks for web mode"
	   (setq web-mode-css-indent-offset 4)
	   (setq web-mode-code-indent-offset 4)
	   (setq web-mode-markup-indent-offset 4))
(add-hook 'web-mode-hook 'my-web-mode-hook)
(add-hook 'web-mode-hook 'emmet-mode)

;; Stuff to (hopefully) address tramp being slow asf on Windows
(setq remote-file-name-inhibit-cache nil)
(setq vc-ignore-dir-regexp
      (format "%s\\|%s"
                    vc-ignore-dir-regexp
                    tramp-file-name-regexp))
(setq tramp-verbose 1)

;; Recompile shortcut
(global-set-key (kbd "C-c r") 'recompile)
(global-set-key (kbd "C-c b") 'compile)

;; Tabs (really more like desktops or something) -- Emacs 27+ only
(global-set-key (kbd "C-c t") 'tab-bar-mode)
(global-set-key (kbd "C-c <insert>") 'tab-new)
(global-set-key (kbd "C-c <delete>") 'tab-close)
(global-set-key (kbd "C-c <prior>") 'tab-previous)
(global-set-key (kbd "C-c <next>") 'tab-next)
(global-set-key (kbd "C-c <up>") 'tab-new) ; alternates for above
(global-set-key (kbd "C-c <down>") 'tab-close)
(global-set-key (kbd "C-c <left>") 'tab-previous)
(global-set-key (kbd "C-c <right>") 'tab-next)
(setq-default tab-bar-position 1)

;; Speedbar in the same frame
(require 'sr-speedbar)
(setq sr-speedbar-right-side nil) ; put on left side

;; Kotlin
(require 'kotlin-mode)
(add-to-list 'auto-mode-alist '("\\.kt\\'" . kotlin-mode))

;; GLSL
(require 'glsl-mode)
(add-to-list 'auto-mode-alist '("\\.(glsl|sc)\\'" . glsl-mode))

;; Lua
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;; CMake
(require 'cmake-mode)
(add-to-list 'auto-mode-alist '("\\CMakeLists.txt\\'" . cmake-mode))

;; Rust
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;; No word wrap
(global-visual-line-mode 0)
(setq-default truncate-lines 1)

;; JOE-style undo/redo
(require 'redo+)
(global-set-key (kbd "C-^") 'redo)

;; from https://stackoverflow.com/a/12990359/1160876
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun delete-word (arg)
  "Delete characters forwards until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-line (arg)
  "Delete (not kill) the current line, backwards from cursor.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (beginning-of-visual-line arg) (point))))

(defun delete-line (arg)
  "Delete (not kill) the current line, forwards from cursor.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (end-of-visual-line arg) (point))))

(defun backward-kill-line (arg)
  "Kill the current line, backwards from cursor.
With argument ARG, do this that many times."
  (interactive "p")
  (kill-region (point) (progn (beginning-of-visual-line arg) (point))))

;; from https://stackoverflow.com/a/35711240/1160876
(defun delete-current-line (arg)
  "Delete (not kill) the current line."
  (interactive "p")
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line arg) (point)))))

;; C-a/Home should alternate between the start of the line and start
;; of the text at its indentation, like most other editors
(require 'mwim)
(global-set-key (kbd "C-a") 'mwim-beginning)
(global-set-key (kbd "C-e") 'mwim-end)
(global-set-key (kbd "<home>") 'mwim-beginning)
(global-set-key (kbd "<end>") 'mwim-end)

;; C-o is delete previous word. Again, another JOE habit
(global-set-key (kbd "C-o") 'backward-delete-word)

;; Also, fix up M-backspace so they delete the word, not
;; kill it
(global-set-key (kbd "M-<backspace>") 'backward-delete-word)

;; I don't really do this nowadays, but I'll leave this here for
;; posterity. You can uncomment these if you want to exclusively use
;; C-<left>, C-<right>, etc. for moving the cursor around, which is a
;; little more consistent with other software.
;(global-set-key (kbd "M-<left>") 'ignore)
;(global-set-key (kbd "M-<right>") 'ignore)
;(global-set-key (kbd "M-S-<left>") 'ignore)
;(global-set-key (kbd "M-S-<right>") 'ignore)
;(global-set-key (kbd "M-<backspace>") 'ignore)
;(global-set-key (kbd "C-<backspace>") 'backward-delete-word)
;(global-set-key (kbd "M-S-<backspace>") 'ignore)

;; Goto line shortcut
(global-set-key (kbd "C-c g") 'goto-line)

;; Delete line shortcut
(global-set-key (kbd "C-k") 'delete-current-line)

;; Fix for stuff like lambdas
(c-add-style "kp"
			 '("gnu"
			   (c-basic-offset . 4)		; Guessed value
			   (c-offsets-alist
				(arglist-cont . 0)		; Guessed value
				(arglist-intro . +)		; Guessed value
				(block-close . 0)		; Guessed value
				(class-close . 0)		; Guessed value
				(class-open . 0)		; Guessed value
				(defun-block-intro . +)	; Guessed value
				(defun-close . 0)		; Guessed value
				(defun-open . 0)		; Guessed value
				(inclass . +)			; Guessed value
				(statement . 0)				; Guessed value
				(statement-block-intro . +) ; Guessed value
				(substatement-open . 0)		; Guessed value
				(topmost-intro . 0)			; Guessed value
				(access-label . -)
				(annotation-top-cont . 0)
				(annotation-var-cont . +)
				(arglist-close . c-lineup-close-paren)
				(arglist-cont-nonempty . c-lineup-arglist)
				(block-open . 0)
				(brace-entry-open . 0)
				(brace-list-close . 0)
				(brace-list-entry . c-lineup-under-anchor)
				(brace-list-intro . +)
				(brace-list-open . 0)
				(c . c-lineup-C-comments)
				(case-label . 0)
				(catch-clause . 0)
				(comment-intro . c-lineup-comment)
				(composition-close . 0)
				(composition-open . 0)
				(cpp-define-intro c-lineup-cpp-define +)
				(cpp-macro . -1000)
				(cpp-macro-cont . +)
				(do-while-closure . 0)
				(else-clause . 0)
				(extern-lang-close . 0)
				(extern-lang-open . 0)
				(friend . 0)
				(func-decl-cont . +)
				(incomposition . +)
				(inexpr-class . +)
				(inexpr-statement . +)
				(inextern-lang . +)
				(inher-cont . c-lineup-multi-inher)
				(inher-intro . +)
				(inlambda . c-lineup-inexpr-block)
				(inline-close . 0)
				(inline-open . 0) ;; used to be +
				(inmodule . +)
				(innamespace . +)
				(knr-argdecl . 0)
				(knr-argdecl-intro . +)
				(label . 2)
				(lambda-intro-cont . +)
				(member-init-cont . c-lineup-multi-inher)
				(member-init-intro . +)
				(module-close . 0)
				(module-open . 0)
				(namespace-close . 0)
				(namespace-open . 0)
				(objc-method-args-cont . c-lineup-ObjC-method-args)
				(objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
				(objc-method-intro .
								   [0])
				(statement-case-intro . +)
				(statement-case-open . 0)
				(statement-cont . +)
				(stream-op . c-lineup-streamop)
				(string . -1000)
				(substatement . +)
				(substatement-label . 2)
				(template-args-cont c-lineup-template-args +)
				(topmost-intro-cont . c-lineup-topmost-intro-cont))))

;; Shift-tab
(global-set-key (kbd "<S-tab>") 'un-indent-by-removing-4-spaces)
(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\t")
        (replace-match "")))))

(setq c-default-style "kp"
      c-basic-offset 4)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("9c4d74bbe19557130fbb1cb97b21c2d3825e6e0c58df6ebb03b80ab5f334ab2d" "32d393be109d30c4a93e601b509603facda9f815a999b7b1ada6c4f8697f7cd6" default))
 '(fringe-mode 0 nil (fringe))
 '(speedbar-default-position 'left))
