;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

(use-package! org-roam
  :after org
  :custom
  (org-roam-directory org-directory)  ;; change this path as needed
  :config
  (org-roam-db-autosync-mode))
  (setq org-agenda-files org-directory)

  (defun org-find-week-in-datetree()
    (org-datetree-find-iso-week-create (calendar-current-date))
    (kill-line))

  '(org-capture-templates
    (quote
     ("w" "Weekly review" plain
      (file+function "~/org/work.org" org-find-week-in-datetree)
      "*** TODO Weekly review\n%?"                ;;\n for newline
   )))


(use-package! org-download
  :after org
  :config
  ;; Enable drag-and-drop images to org buffers
  (add-hook 'org-mode-hook #'org-download-enable))

;; Optional settings
(setq org-download-method 'directory
      org-download-image-dir "./images"
      org-download-heading-lvl nil
      org-download-timestamp "%Y%m%d-%H%M%S_"
      org-image-actual-width 300)

(setq org-mobile-directory "~/orgmobile/")
(setq
  org-gcal-client-id "1033652523374-3gekfdeag02nrgvf7qakn0oi1tff4cbo.apps.googleusercontent.com"
  org-gcal-client-secret "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"
  org-gcal-fetch-file-alist '(("your-mail@gmail.com" .  "~/gmail.org")))


(use-package! vhdl-ts-mode
  :after vhdl-mode
 )

;; (use-package! lsp-bridge)
(use-package! vhdl-ext
  :after vhdl-mode
  :config(setq vhdl-ext-feature-list
      '(font-lock
        xref
        capf
        hierarchy
        eglot
        lsp
        ;; lsp-bridge
        ;; lspce
        flycheck
        beautify
        navigation
        template
        compilation
        imenu
        which-func
        hideshow
        time-stamp
        ports))
(vhdl-ext-mode-setup)

(add-hook 'vhdl-mode-hook #'vhdl-ext-mode)
 (with-eval-after-load 'eglot

  (with-eval-after-load 'typst-ts-mode

    (add-to-list 'eglot-server-programs

                 `((typst-ts-mode) .

                   ,(eglot-alternatives `(,typst-ts-lsp-download-path

                                          "tinymist"

                                          "typst-lsp")))))) )
(use-package websocket)
(use-package typst-preview)

(setq tramp-terminal-type "tramp")

(defun my/open-alt-config ()
  "Open my alternative config directory instead of `doom-user-dir'."
  (interactive)
  (doom-project-browse "~/nixos-config/home-manager/doom/"))

(advice-add #'+doom/open-private-config :override #'my/open-alt-config)
