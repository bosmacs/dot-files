;; Temporarily increase GC threshold during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Restore to normal value after startup (e.g. 50MB)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 50 1024 1024))))

(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1))
  (menu-bar-mode -1))
