(in-package :cl-user)

(print ">>> Building system....")

;;;(load (make-pathname :directory *build-dir* :defaults "md5-1.8.5/md5.asd"))
(load (make-pathname :directory *build-dir* :defaults "example.asd"))

;;;(ql:quickload :md5-system)
(ql:quickload :example)

;;; Redefine / extend heroku-toplevel here if necessary.

(print ">>> Done building system")
