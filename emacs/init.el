;;; init.el --- Where all the magic begins
;;
;; This file loads Org-mode and then loads the rest of our Emacs initialization from Emacs lisp
;; embedded in literate Org-mode files.

;; Load up Org Mode and (now included) Org Babel for elisp embedded in Org Mode files
(setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))

;; initialize package management
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )

(when (< emacs-major-version 27)
  (package-initialize))

;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  ;;(add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

;;

;;(require 'cask "/opt/local/share/cask/cask.el")
;;(cask-initialize)
;;(require 'pallet)
;;(pallet-mode t)

(when (memq window-system '(mac ns))
  (use-package exec-path-from-shell
    :ensure t
    :init
    (exec-path-from-shell-initialize)))

;; for package compatibility with emacs < 24
;;(when (< emacs-major-version 24)
;;  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; load up Org-mode and Org-babel
(require 'org)
(require 'ob-tangle)

;; load up all literate org-mode files in this directory
(mapc #'org-babel-load-file (directory-files dotfiles-dir t "\\.org$"))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(background-color "#042028")
 '(background-mode dark)
 '(column-number-mode t)
 '(connection-local-criteria-alist
   '(((:machine "bernoulli") bernoulli-vars) ((:application vc-git) vc-git-connection-default-profile)
     ((:application eshell) eshell-connection-default-profile)
     ((:application tramp :machine "localhost") tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "poincare.bosma.home") tramp-connection-local-darwin-ps-profile)
     ((:application tramp) tramp-connection-local-default-system-profile
      tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((bernoulli-vars (company-gtags--executable-connection))
     (vc-git-connection-default-profile (vc-git--program-version))
     (eshell-connection-default-profile (eshell-path-env-list))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o"
                                        "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        "-o" "state=abcde" "-o"
                                        "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format (pid . number) (euid . number) (user . string)
                                          (egid . number) (comm . 52) (state . 5) (ppid . number)
                                          (pgrp . number) (sess . number) (ttname . string)
                                          (tpgid . number) (minflt . number) (majflt . number)
                                          (time . tramp-ps-time) (pri . number) (nice . number)
                                          (vsize . number) (rss . number) (etime . tramp-ps-time)
                                          (pcpu . number) (pmem . number) (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o"
                                        "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format (pid . number) (user . string) (group . string)
                                          (comm . 52) (state . 5) (ppid . number) (pgrp . number)
                                          (ttname . string) (time . tramp-ps-time) (nice . number)
                                          (etime . tramp-ps-time) (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o"
                                        "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        "-o"
                                        "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format (pid . number) (euid . number) (user . string)
                                          (egid . number) (group . string) (comm . 52)
                                          (state . string) (ppid . number) (pgrp . number)
                                          (sess . number) (ttname . string) (tpgid . number)
                                          (minflt . number) (majflt . number) (time . tramp-ps-time)
                                          (pri . number) (nice . number) (vsize . number)
                                          (rss . number) (etime . number) (pcpu . number)
                                          (pmem . number) (args)))
     (tramp-connection-local-default-shell-profile (shell-file-name . "/bin/sh")
                                                   (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile (path-separator . ":")
                                                    (null-device . "/dev/null"))))
 '(cursor-color "#708183")
 '(custom-safe-themes
   '("5d1ef40b7ae10bd04f17eb98e6b7a1832e254948e4da4abe9a0ee290a9b676e0"
     "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4"
     "d2622a2a2966905a5237b54f35996ca6fda2f79a9253d44793cfe31079e3c92b"
     "501caa208affa1145ccbb4b74b6cd66c3091e41c5bb66c677feda9def5eab19c"
     "54d1bcf3fcf758af4812f98eb53b5d767f897442753e1aa468cfeb221f8734f9"
     "baed08a10ff9393ce578c3ea3e8fd4f8c86e595463a882c55f3bd617df7e5a45"
     "485737acc3bedc0318a567f1c0f5e7ed2dfde3fb" "1440d751f5ef51f9245f8910113daee99848e2c0"
     "5600dc0bb4a2b72a613175da54edb4ad770105aa" "0174d99a8f1fdc506fa54403317072982656f127" default))
 '(foreground-color "#708183")
 '(global-hl-line-mode t)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(bind-key bury-successful-compilation cdlatex cmake-mode company-fuzzy company-quickhelp counsel
              csv-mode dap-mode deadgrep diff-hl edit-indirect eshell-vterm ess exec-path-from-shell
              fish-mode flx flycheck flyspell-correct-ivy fontaine geiser gmsh-mode
              graphviz-dot-mode haskell-mode ivy-rich julia-vterm latex-extra lean4-mode list-utils
              lsp-haskell lsp-julia lsp-latex lsp-python-ms lsp-scheme lsp-ui macports magit
              markdown-ts-mode mermaid-mode mermaid-ts-mode modus-themes nix-mode nix-ts-mode nixfmt
              org-bullets pcre2el projectile quarto-mode roc-ts-mode smart-mode-line smartparens
              solarized-theme swift-mode wgsl-mode which-key yaml-mode))
 '(package-vc-selected-packages
   '((lean4-mode :url "https://github.com/leanprover-community/lean4-mode.git")))
 '(paren-match-face 'paren-face-match-light)
 '(paren-sexp-mode t)
 '(remote-shell-program "/usr/bin/ssh")
 '(ring-bell-function 'ignore)
 '(safe-local-variable-values '((org-export-allow-bind-keywords . t)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(warning-suppress-types '((ess) (lsp-mode) (comp))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:background "nil"))))
;;  '(font-lock-keyword-face ((t (:background "nil"))))
;;  '(fringe ((t (:foreground "#002b36"))))
;;  '(which-func ((t (:inherit font-lock-constant-face)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 150))))
 '(fixed-pitch ((t (:family "JetBrains Mono"))))
 '(fringe ((t (:foreground "#002b36"))))
 '(which-func ((t (:inherit font-lock-constant-face)))))
