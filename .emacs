;; font size in units of 1/10 point.
(set-face-attribute 'default nil :height 110)

;; set frame startup size in number of characters
(setq initial-frame-alist
      '((top . 1) (left . 1) (width . 80) (height . 30)))

;; Need to set style before loading ess.
(setq ess-default-style 'RStudio)
(load "ess-site.el")

;; Most important ESS options.
(setq ess-eval-visibly-p nil)
(setq ess-ask-for-ess-directory nil)
(setq ess-eldoc-show-on-symbol t)
(setq ess-default-style 'RStudio)
(setq ess-startup-directory 'default-directory);;https://github.com/emacs-ess/ESS/issues/1187#issuecomment-1038360149
(setq inferior-R-program "/usr/bin/R");on ubuntu with https://github.com/eddelbuettel/r2u
(with-eval-after-load "ess-mode" 
  (define-key ess-mode-map ";" #'ess-insert-assign)
  (define-key inferior-ess-mode-map ";" #'ess-insert-assign)
  )
(setq tab-always-indent 'complete)

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
;; for compiling R packages.
(global-set-key [f9] 'compile)
(add-to-list 'safe-local-variable-values '(compile-command . "R -e \"Rcpp::compileAttributes('..')\" && R CMD INSTALL .. && R --vanilla < ../tests/testthat/test-CRAN.R"))
(add-to-list 'safe-local-variable-values '(compile-command . "R -e \"devtools::test()\""))
(global-set-key [f10] 'evince-pdf)

;;c-mode.
(setq c-auto-newline nil)
(add-hook 'c-mode-hook
	  (lambda () 
	    (c-set-style "bsd")
	    (setq c-basic-offset 4)))

;; TeX
(setq TeX-PDF-mode t)
(load "auctex" t)
(load "preview-latex" t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; Open dictionaries in browser.
(defun larousse ()
  "Lookup the word at point using Larousse."
  (interactive)
  (browse-url (concat "https://www.larousse.fr/dictionnaires/francais/"
		      (thing-at-point 'word)))
)
(global-set-key "\C-x\C-y" 'larousse)
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



;;https://github.com/vspinu/polymode (only supports emacs >= 24.4)
(if (version< emacs-version "24.4") 
    ;;http://ftpmirror.gnu.org/emacs/
    (message "emacs too old, not loading polymode")
    (and (add-to-list 'load-path "~/polymode")
	 (add-to-list 'load-path "~/polymode/modes")
	 ;;http://jblevins.org/projects/markdown-mode/markdown-mode.el
	 (autoload 'poly-markdown+r-mode "poly-R.el" "Rmd" t)
	 (autoload 'markdown-mode "markdown-mode.el" "markdown" t)
	 (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))))
;; https://github.com/melpa/melpa#usage
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
;;excute all code blocks in an Rmd.
(defun Rmd-execute-all-code-blocks ()
  "Run keyboard macro until bell rings"
  (interactive)
  (execute-kbd-macro "\C-s```{\C-n\C-a\C- \C-s```\C-p\C-e\C-c\C-r" 0)
  )

(require 'mu4e)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

;; default
;; (setq mu4e-maildir "~/Maildir")

(setq mu4e-drafts-folder "/Drafts")
(setq mu4e-sent-folder   "/Sent Items")
(setq mu4e-trash-folder  "/Deleted Items")

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; (See the documentation for `mu4e-sent-messages-behavior' if you have
;; additional non-Gmail addresses and want assign them different
;; behavior.)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.

(setq mu4e-maildir-shortcuts
    '( ("/INBOX"               . ?i)
       ("/Sent Items"   . ?s)
       ("/Deleted Items"       . ?t)
       ("/All Mail"    . ?a)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; something about ourselves
(setq
   user-mail-address "toby.hocking@nau.edu"
   user-full-name  "Toby Dylan Hocking"
   mu4e-compose-signature
   "Toby Dylan Hocking, Ph.D.
http://tdhock.github.io
*** Please understand, to be productive in my teaching and my research,
I try to check my email no more than once per day. As such, please be
prepared for a 24 to 48 hour delay in my response. If this matter is
something that requires immediate attention, please visit/call my office.
")

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
   starttls-use-gnutls t
   smtpmail-starttls-credentials '(("iris.nau.edu" 587 nil nil))
   smtpmail-auth-credentials
     '(("iris.nau.edu" 587 "th798@iris.nau.edu" nil))
   smtpmail-default-smtp-server "iris.nau.edu"
   smtpmail-smtp-server "iris.nau.edu"
   smtpmail-smtp-service 587)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)
(setq mu4e~get-mail-password-regexp "^Enter password for account 'Remote': $")
