;; font size in units of 1/10 point.
(set-face-attribute 'default nil :height 110)

;; arduino-mode
;; sudo aptitude install arduino arduino-mk (installs a perl command line prog)
;; git clone git://github.com/bookest/arduino-mode.git
(add-to-list 'load-path "~/arduino-mode")
(add-to-list 'auto-mode-alist '("\\.\\(pde\\|ino\\)$" . arduino-mode))
(autoload 'arduino-mode "arduino-mode.el" "Arduino editing mode" t)
;; git clone git://github.com/sudar/Arduino-Makefile
;; put "include ~/Arduino-Makefile/Arduino.mk" in Makefile.
(add-hook 'arduino-mode-hook 
	  (lambda ()
;; make compile-command buffer-local so that "make upload" is not used
;; for other projects.
	    (set (make-local-variable 'compile-command) "make upload")))

;;ess-mode NOTE: if site-wide file is present, it is read first, and
;;if it loads ess, then the following code will not do anything!
;;Furthermore, if we need to load user-specific ESS, then we need to
;;start emacs with --no-site-file or (unload-feature ...) here
(autoload 'R "ess-site.el" "ESS" t)
(autoload 'R-mode "ess-site.el" "ESS" t)
(autoload 'r-mode "ess-site.el" "ESS" t)
(autoload 'Rd-mode "ess-site.el" "ESS" t)
(autoload 'Rnw-mode "ess-site.el" "ESS" t)
(add-to-list 'auto-mode-alist '("\\.R$" . R-mode))
(add-to-list 'auto-mode-alist '("\\.r$" . R-mode))
(add-to-list 'auto-mode-alist '("\\.Rd$" . Rd-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw$" . Rnw-mode))
;; Most important ESS options.
(setq ess-eval-visibly-p nil)
(setq ess-ask-for-ess-directory nil)
(require 'ess-eldoc "ess-eldoc" t)
(setq ess-eldoc-show-on-symbol t)

;; ggplot indentation https://github.com/emacs-ess/ESS/issues/120
(load "ess-site.el")
(add-to-list 'ess-style-alist
 '(tdh-style
   (ess-indent-level default-value 'ess-indent-level)

   (ess-first-continued-statement-offset . 2)
   (ess-continued-statement-offset . 0)

   (ess-brace-offset default-value 'ess-brace-offset)
   (ess-expression-offset default-value 'ess-expression-offset)
   (ess-else-offset default-value 'ess-else-offset)
   (ess-brace-imaginary-offset default-value 'ess-brace-imaginary-offset)
   (ess-continued-brace-offset default-value 'ess-continued-brace-offset)
   (ess-arg-function-offset default-value 'ess-arg-function-offset)
   (ess-arg-function-offset-new-line default-value 'ess-arg-function-offset-new-line)
   (ess-close-brace-offset default-value 'ess-close-brace-offset))
)
(setq ess-default-style 'tdh-style)
;; from http://ygc.name/2014/12/07/auto-complete-in-ess/
(add-to-list 'load-path "~/auto-complete-1.3.1")
(setq ess-use-auto-complete t)
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/auto-complete-1.3.1/dict")
(ac-config-default)
(auto-complete-mode)
(setq ac-auto-start nil)
;(setq ac-auto-start 5)
(setq ac-quick-help-delay 2)
(define-key ac-mode-map [C-tab] 'auto-complete);C-tab auto-complete
(setq ess-describe-at-point-method 'tooltip);C-c C-d C-e C-e help window


;; Emacs stuff.
(global-set-key "\M-s" 'isearch-forward-regexp)
(global-set-key "\M-r" 'isearch-backward-regexp)
(if (functionp 'tool-bar-mode) (tool-bar-mode 0))
(if (functionp 'scroll-bar-mode) (scroll-bar-mode -1))
(menu-bar-mode 0)
(setq inhibit-startup-screen t)
(show-paren-mode 1)

;; Org.
(setq org-src-fontify-natively t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; JavaScript
(setq js-indent-level 2)

;; Compile with F9, view PDF with F10.
(setq compilation-scroll-output t)
(setq compile-command "make ")
(setq compilation-read-command nil)
(defun evince-pdf ()
  "homebrew view pdf, convenient from latex"
  (interactive)
  ;;(expand-file-name "~/foo")
  ;;(shell-quote-argument "some file with spaces")
  (shell-command
   (concat "evince " (file-name-sans-extension (buffer-file-name)) ".pdf &"))
)
(global-set-key [f9] 'compile)
(global-set-key [f10] 'evince-pdf)

;;c-mode.
(setq c-auto-newline nil)
(add-hook 'c-mode-hook
	  (lambda () 
	    (c-set-style "bsd")
	    (setq c-basic-offset 4)))

;; Edit pt templates in HTML-mode.
(add-to-list 'auto-mode-alist '("\\.pt$" . html-mode))

;; TeX
(setq TeX-PDF-mode t)
(load "auctex" t)
(load "preview-latex" t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; Open a browser to translate a word.
(defun translate ()
  "Translate the word at point using WordReference."
  (interactive)
  (browse-url (concat "http://www.wordreference.com/fren/" 
		      (thing-at-point 'word)))
)
(global-set-key "\C-x\C-m" 'translate)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; frame titles.
(setq frame-title-format
      (concat  "%b - emacs@" system-name))

;; default to unified diffs
(setq diff-switches "-u")

;;svn-in-emacs mode
(load "psvn" t)
(setq vc-follow-symlinks t)

;elisp
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)



;;polymode (only supports emacs >= 24.4)
(if (version< emacs-version "24.4") 
    (message "emacs too old, not loading polymode")
    (and (add-to-list 'load-path "~/polymode")
	 (add-to-list 'load-path "~/polymode/modes")
	 ;;http://jblevins.org/projects/markdown-mode/markdown-mode.el
	 (autoload 'poly-markdown+r-mode "poly-R.el" "Rmd" t)
	 (autoload 'markdown-mode "markdown-mode.el" "markdown" t)
	 (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))))
