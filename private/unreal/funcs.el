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


(defun unreal-project-p ()
  "test if current project is a Unreal project"
  (some (lambda (s) (string-match ".*\.uproject" s)) (directory-files (projectile-project-root)))
  )

(defun unreal-find-cpp ()
  "In a .h file, find or create a corresponding .cpp file"
  (if (not (unreal-project-p))
      (error "Not a Unreal project"))
  
  ;; find in current directory
  (let ((directory (file-name-directory (buffer-file-name)))
        (filename (file-name-base (buffer-file-name)))
        (extension (file-name-extension (buffer-file-name))))

    (if (not (equal extension "h"))
        (error "Not a header file"))

    (let ((cpp-name (concat directory filename ".cpp")))
      ;; when .cpp exists in the same directory
      (if (file-exists-p cpp-name)
          (find-file cpp-name)

        ;; when .h is in some Public path
        (if (string-match "^\\(.*\\)\\/Public\\/\\(.*\\)$" directory)
            (let ((cpp-name (concat (match-string 1 directory)
                                    "/Private/"
                                    (match-string 2 directory)
                                    filename
                                    ".cpp")))
              ;; find or create .cpp is in corresponding Private path
              (find-file cpp-name))
          ;; create .cpp in the same path
          (find-file cpp-name)
          )
        )
      )
    )
  )

(defun unreal-find-h ()
  "In a .cpp file, find or create a corresponding .h file"
  (if (not (unreal-project-p))
      (error "Not a Unreal project"))
  
  ;; find in current directory
  (let ((directory (file-name-directory (buffer-file-name)))
        (filename (file-name-base (buffer-file-name)))
        (extension (file-name-extension (buffer-file-name))))

    (if (not (equal extension "cpp"))
        (error "Not a cpp file"))

    (let ((h-name (concat directory filename ".h")))
      ;; when .h exists in the same directory
      (if (file-exists-p h-name)
          (find-file h-name)

        ;; when .cpp is in some Private path
        (if (string-match "^\\(.*\\)\\/Private\\/\\(.*\\)$" directory)
            (let ((h-name (concat (match-string 1 directory)
                                  "/Public/"
                                  (match-string 2 directory)
                                  filename
                                  ".h")))
              ;; find or create .h is in corresponding Private path
              (find-file h-name))
          ;; create .h in the same path
          (find-file h-name)
          )
        )
      )
    )
  )

(defun unreal-visit-other ()
  "In a .h or .cpp file, visit the other file"
  (interactive)
  (let ((ext (file-name-extension (buffer-file-name))))
    (cond
     ((equal ext "h") (unreal-find-cpp))
     ((equal ext "cpp") (unreal-find-h)))
    )
  )

(defun unreal-visit-other-other-window ()
  "In a .h or .cpp file, visit the other file"
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (unreal-visit-other)
  )


