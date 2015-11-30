(asdf:defsystem #:remon-service
  :description "Remember the monitor layout and automatically apply it"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT license"
  :serial t
  :depends-on (:inotify :remon :sqlite)
  :components ((:module "src"
                :components ((:file "packages")
                             (:file "remon-service")))))
