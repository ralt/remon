(in-package #:remon)

(defvar *edids-pathname* (pathname "/sys/class/drm/card0-*/edid"))
(defvar *edid-length* 128)

(defun read-file-bytes (file buffer buffer-offset)
  (with-open-file (f file :element-type '(unsigned-byte 8))
    (read-sequence buffer f :start buffer-offset)))

(defun get-edids-sum ()
  (md5sum (read-edids)))

(defun read-edids ()
  (let* ((edid-files (directory *edids-pathname*))
         (buffer (make-array (* (length edid-files) *edid-length*)
                             :element-type '(unsigned-byte 8)))
         (buffer-offset 0))
    (multiple-value-prog1 buffer
      (dolist (file edid-files)
        (read-file-bytes file buffer buffer-offset)
        (incf buffer-offset *edid-length*)))))

(defun md5sum (buffer)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence :md5 buffer)))
