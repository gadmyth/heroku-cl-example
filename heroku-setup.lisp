(in-package :cl-user)

(export '*build-dir*)
(print "build-dir:")
(print *build-dir*)

(print ">>> Building system....")

(load (make-pathname :defaults *build-dir* :name "md5-1.8.5/md5" :type "asd"))
(load (make-pathname :defaults *build-dir* :name "example" :type "asd"))

(ql:quickload :md5)
(ql:quickload :example)

;;; Redefine / extend heroku-toplevel here if necessary.

(print ">>> Done building system")
