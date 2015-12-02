(in-package #:remon-service)

(defvar *statuses-pathname* (pathname "/sys/class/drm/card0-*/status"))

(defun main (args)
  (declare (ignore args))
  (remon:setup-db)
  (dolist (f (directory *statuses-pathname*))
    (watch f #'apply-known-configuration)))

(defun watch (file callback)
  (inotify:with-inotify (inot `((,file ,inotify:in-modify)))
    (let ((foo (inotify:read-events inot)))
      ;; Just wait for inotify to pick up something
      (declare (ignore foo))
      (funcall callback))))

(defun apply-known-configuration ()
  (sqlite:with-open-database (db remon:*db-path*)
    (let ((edids (remon:get-edids-sum)))
      (when (remon:edids-exists db edids)
        (remon:run-xrandr (remon:get-xrandr-args db edids))))))
