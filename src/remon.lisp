(in-package #:remon)

(defun main (args)
  (let ((xrandr-args (format-args (rest args))))
    (save-configuration (get-edids-sum) xrandr-args)
    (run-xrandr xrandr-args)))

(defun format-args (args)
  (format nil "~{~A~^ ~}" args))
