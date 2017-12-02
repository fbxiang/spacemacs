;;; funcs.el --- Gnome utility functions for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: fbxiang
;; URL: https://github.com/fbxiang
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

(defun spacemacs/maim-latex (filename)
  (interactive "sName of the image: ")
  (let ((file-path (concat default-directory filename ".png")))
    (progn
      (sleep-for 3)
      (shell-command (concat "maim -s > " file-path))
      (insert (concat "\\begin{figure}\n\\centering\n\\includegraphics[]{" filename ".png}\n\\end{figure}"))
      )
    )
  )

(defun spacemacs/gnome-screenshot (filename)
  "Take a screenshot and save it to default directory"
  (interactive "sName of the image: ")
  (let ((file-path (concat default-directory filename ".png")))
    (progn
      ;; (if (string-match-p "/" filename) (error "image name is invalid"))
      (shell-command (concat "gnome-screenshot -a -f " file-path))))
  )

(defun spacemacs/gnome-org-screenshot (filename)
  "Take a screenshot, save it to default directory and create a org style link"
  (interactive "sName of the image: ")
  (progn
    (spacemacs/gnome-screenshot filename)
    (insert (concat "[[file:" filename ".png]]")))
  )

(defun spacemacs/latex-screenshot (filename)
  "Take a screenshot, save it to default directory and create a org style link"
  (interactive "sName of the image: ")
  (progn
    (sleep-for 1)
    (spacemacs/gnome-screenshot filename)
    (insert (concat "\\begin{figure}\n\\centering\n\\includegraphics[width=\\linewidth]{"
                    filename
                    ".png}\n\\end{figure}")))
  )

(defun spacemacs/terminal ()
  "Open a gnome terminal at default directory"
  (interactive)
  (shell-command "urxvt > /dev/null 2>&1 & disown")
  )

(defun spacemacs/projectile-terminal ()
  "Open a gnome terminal at project root"
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (call-interactively 'spacemacs/terminal))
  )
