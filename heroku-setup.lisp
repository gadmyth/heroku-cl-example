(in-package :cl-user)

(print ">>> Building system....")

(load (make-pathname :directory *build-dir* :name "md5-1.8.5/md5" :type "asd"))
(load (make-pathname :directory *build-dir* :defaults "example.asd"))

(format t "~A~%" *build-dir*)

(ql:quickload :md5)
(ql:quickload :example)

;;; Redefine / extend heroku-toplevel here if necessary.

(print ">>> Done building system")
