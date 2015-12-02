(defpackage #:remon
  (:use #:cl)
  (:export :main
           :*db-path*
           :setup-db
           :get-edids-sum
           :get-edids
           :edids-exists
           :run-xrandr
           :get-xrandr-args))

(defpackage #:remon-service
  (:use #:cl)
  (:export :main))
