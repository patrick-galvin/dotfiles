
;; init.el ends here

;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)


(add-to-list 'package-archives
  '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))

(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/"))

(add-to-list 'package-archives
  '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; CLOJURE 
;; --------------------------------------

(require 'which-key)
(which-key-mode)

(setq cider-prompt-save-file-on-load nil)
(setq cider-prompt-save-file-on-load 'always-save)

(setq inhibit-startup-message t) 
(load-theme 'material t) 
(global-linum-mode t) 

(global-company-mode)

(defun turn-on-paredit () (paredit-mode 1))

(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(setq nrepl-hide-special-buffers t)

(setq nrepl-popup-stacktraces nil)

(show-paren-mode 1)

;; PYTHON 
;; --------------------------------------

(elpy-enable)
(elpy-use-ipython)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
