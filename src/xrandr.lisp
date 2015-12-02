(in-package #:remon)

(defun run-xrandr (args)
  (uiop:run-program (format nil "xrandr ~A" args)))
