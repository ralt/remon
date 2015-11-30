(in-package #:remon)

(defun run-xrandr (args)
  (uiop:run-program "xrandr ~A" args))
