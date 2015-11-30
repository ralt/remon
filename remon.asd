(asdf:defsystem #:remon
  :description "Remember the monitor layout and automatically apply it"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT license"
  :serial t
  :depends-on (:sqlite :ironclad)
  :components ((:module "src"
                :components ((:file "packages")
                             (:file "db")
                             (:file "edid")
                             (:file "remon")))))
