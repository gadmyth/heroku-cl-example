(in-package #:example)

;; Utils
(defun heroku-getenv (target)
  #+ccl (ccl:getenv target)
  #+sbcl (sb-posix:getenv target))

;; Database
(defvar *database-url* (heroku-getenv "DATABASE_URL"))

(defun db-params ()
  "Heroku database url format is postgres://username:password@host/database_name.
TODO: cleanup code."
  (let* ((url (second (cl-ppcre:split "//" *database-url*)))
	 (user (first (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (password (second (cl-ppcre:split ":" (first (cl-ppcre:split "@" url)))))
	 (host (first (cl-ppcre:split "/" (second (cl-ppcre:split "@" url)))))
	 (database (second (cl-ppcre:split "/" (second (cl-ppcre:split "@" url))))))
    (list database user password host)))


;(pprint *features*)

(defmacro with-app (str)
  #+local-h 
  str
  #-local-h
  (concatenate 'string "/app/" str))


;; Handlers
(push (hunchentoot:create-folder-dispatcher-and-handler "/static/" (with-app "public/"))
      hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/cydia/" (with-app "public/cydia/"))
      hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/cydia/tpime/v3.2.2/" (with-app "public/cydia/tpime/v3.2.2/"))
      hunchentoot:*dispatch-table*)

(push (hunchentoot:create-static-file-dispatcher-and-handler "/cydia/Release" (with-app "public/cydia/Release") "text/plain")
      hunchentoot:*dispatch-table*)

(push (hunchentoot:create-static-file-dispatcher-and-handler "/cydia/Packages" (with-app "public/cydia/Packages") "text/plain")
      hunchentoot:*dispatch-table*)


(hunchentoot:define-easy-handler (cydia-source :uri "/cydia") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
       (:link :rel "shortcut icon" :href "static/favicon.ico" :type "image/x-icon")
       (:link :rel "stylesheet" :type "text/css" :href "static/default.css")
       (:title "Cydia Source"))
     (:body
      (:h6 (format s "build-dir: ~A" (eval (find-symbol "*BUILD-DIR*" (find-package :cl-user)))))
      (:h6 (format s "~A" (md5:md5sum-file #p"./public/cydia/tpime/v3.2.2/TouchPalIME.deb")))
      (:h6 (format s "~A" (md5:md5sum-sequence "1234567890")))
      (:a :href "https://devcenter.heroku.com/articles/read-only-filesystem" "you can load file to #p\"./tmp\"")
      (:div
       	(:h5 (format s "The followings are app into hacked iphones:"))
	(:a :href "cydia/tpime/v3.2.2/TouchPalIME.deb" "TouchPal IME for IOS 6,7 v3.2.2, release, 2014.1.28"))
	(:p)
      ))))

(defvar *register-table* (make-hash-table :test #'equal))
(hunchentoot:define-easy-handler (software-register :uri "/soft-regist") ()
  (cl-who:with-html-output-to-string (s)
    (:html 
     (:head
      (:link :rel "shortcut icon" :href "static/favicon.ico" :type "image/x-icon")
      (:title "Cydia Source"))
     (:body
      (:div
       (:h6 (let* ((para (hunchentoot:parameter "serial"))
		   (number (if para (format nil "~a" para) "0"))
		   (xor-number (format nil "~x" (logxor #x10FE5A (parse-integer number :radix 16))))
		   (serial-number (eval `(concatenate 'string ,@(map 'list (lambda (x) (format nil "~x" x)) (md5:md5sum-sequence xor-number))))))
	      (let (result)
		(if (not (equal "0" number))
		  (if (< (hash-table-count *register-table*) 5)
		      (setf (gethash number *register-table*) serial-number)))
		(setf result (gethash number *register-table*))
		(if result (format s "~A" serial-number))))))

      (:div
       (:h6 (maphash (lambda (k v) (format s "~A, ~A~%" k v)) *register-table*)))
      ))))

(hunchentoot:define-easy-handler (hello-sbcl :uri "/") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
       (:link :rel "shortcut icon" :href "static/favicon.ico" :type "image/x-icon")
       (:link :rel "stylesheet" :type "text/css" :href "static/default.css")
       (:title "Workspace of Gadmyth"))
     (:body
      (:h1 :class "space_title" "Welcome to Gadmyth's workspace!")
      (:a :href "static/lisp-glossy.jpg" (:img :src "static/head.jpeg" :width 100))
      (:h3 "Environment of workspace：")
      (:ul
       (:li (format s "~A ~A" (lisp-implementation-type) (lisp-implementation-version)))
       (:li (format s "Hunchentoot ~A" hunchentoot::*hunchentoot-version*))
       (:li (format s "CL-WHO")))
      (:p)
      (:div
       (:a :href "/cydia" "TouchPal Input Method of iOS Cydia resoure" (:img :src "static/cydia.png" :width 50 :height 50)))
      (:p)
      (:div
       (:a :href "static/hello.txt" "hello"))
      (:div
       (:a :href "static/ecl-shell-example.txt" "ecl shell example"))
      (:p)
      (:div
       (:a :href "static/goagent-goagent-v2.1.11-86-g107a853.zip" "goagent(zip)"))
      (:p)
      (:div
       (:a :href "static/Basic.Introduction.To.Lisp.ppt" "Basic Introduction to Lisp ( ppt )"))
      (:div
       (:a :href "static/BITL.pdf" "Basic Introduction to Lisp ( pdf )"))
      (:div
       (:p)
       (:a :href "static/dvzhengma.tar.bz2" "ZhengMa Input Method Dvorak Under Mac")
       (:br)
       (:a :href "static/dv.zhengma.tar.bz2" "ZhengMa Input Method Dvorak Under Linux Yong"))
      (:div
       (:p)
       (:a :href "mailto:gadmyth@gmail.com" "Email Me"))
      ;;(:h3 "App Database")
      ;;(:div
       ;;(:pre "SELECT version();"))
      ;;(:div (format s "~A" (postmodern:with-connection (db-params)
	;;		     (postmodern:query "select version()"))))
      ))))
