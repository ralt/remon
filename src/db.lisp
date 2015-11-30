(in-package #:remon)

(defvar *db-path* (merge-pathnames #p".remon.db" (user-homedir-pathname)))

(defvar *create-table-query* "
create table if not exists configurations (
    edids varchar(32) unique not null,
    xrandr_options text not null
)")

(defun setup-db ()
  (sqlite:with-open-database (db *db-path*)
    (sqlite:execute-single db *create-table-query*)))

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
