(in-package #:remon)

(defvar *db-path* #p"/var/lib/remon/db")

(defvar *create-table-query* "
create table if not exists configurations (
    edids varchar(32) unique not null,
    xrandr_options text not null
)")

(defun setup-db ()
  (let ((db-directory (directory-namestring *db-path*)))
    (ensure-directories-exist db-directory)
    (sqlite:with-open-database (db *db-path*)
      (sqlite:execute-single db *create-table-query*))
    (sb-posix:chmod db-directory #o0777)
    (sb-posix:chmod *db-path* #o0666)))

(defun save-configuration (edids xrandr-args)
  (sqlite:with-open-database (db *db-path*)
    (sqlite:with-transaction db
      (if (edids-exists db edids)
          (update-edids db edids xrandr-args)
          (create-edids db edids xrandr-args)))))

(defvar *edids-exists-query* "
select edids
from configurations
where edids = ~S")

(defun edids-exists (db edids)
  (sqlite:execute-single db (format nil *edids-exists-query* edids)))

(defvar *edids-update-query* "
update configurations
set xrandr_options = ~S
where edids = ~S")

(defun update-edids (db edids xrandr-args)
  (sqlite:execute-single db (format nil
                                    *edids-update-query*
                                    xrandr-args
                                    edids)))

(defvar *edids-create-query* "
insert into configurations (edids, xrandr_options)
values(~S, ~S)")

(defun create-edids (db edids xrandr-args)
  (sqlite:execute-single db (format nil
                                    *edids-create-query*
                                    edids
                                    xrandr-args)))

(defvar *get-xrandr-args-query* "
select xrandr_options
from configurations
where edids = ~S")

(defun get-xrandr-args (db edids)
  (sqlite:execute-single db (format nil *get-xrandr-args-query* edids)))
