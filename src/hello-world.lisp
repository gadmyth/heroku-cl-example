(in-package :example)

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

;; Handlers
(push (hunchentoot:create-folder-dispatcher-and-handler "/static/" "/app/public/")
      hunchentoot:*dispatch-table*)

(push (hunchentoot:create-folder-dispatcher-and-handler "/cydia/" "/app/public/cydia/")
      hunchentoot:*dispatch-table*)

(push (hunchentoot:create-static-file-dispatcher-and-handler "/cydia/Release" "/app/public/cydia/Release" "text/plain")
      hunchentoot:*dispatch-table*)

(push (hunchentoot:create-static-file-dispatcher-and-handler "/cydia/Packages" "/app/public/cydia/Packages" "text/plain")
      hunchentoot:*dispatch-table*)

(hunchentoot:define-easy-handler (cydia-source :uri "/cydia") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
       (:link :rel "shortcut icon" :href "static/favicon.ico" :type "image/x-icon")
       (:title "Cydia Source"))
     (:body
      (:h6 (format s "build-dir: ~A" (eval (find-symbol "*BUILD-DIR*" (find-package :cl-user)))))
      (:h6 (format s "~A" (md5:md5sum-file #p"./public/cydia/tpime/TouchPalIME.deb")))
      (:h6 (format s "~A" (md5:md5sum-sequence "1234567890")))
      (:a :href "https://devcenter.heroku.com/articles/read-only-filesystem" "you can load file to #p\"./tmp\"")
      (:div
       	(:h5 (format s "The followings are app into hacked iphones:"))
	(:a :href "cydia/tpime/TouchPalIME.deb" "TouchPal IME for IOS 4,5 v2.2.1"))
      ))))

(hunchentoot:define-easy-handler (hello-sbcl :uri "/") ()
  (cl-who:with-html-output-to-string (s)
    (:html
     (:head
       (:link :rel "shortcut icon" :href "static/favicon.ico" :type "image/x-icon")
       (:title "Workspace of Gadmyth"))
     (:body
      (:h1 "Welcome to my workspace!")
      (:h3 "Environment of workspace：")
      (:ul
       (:li (format s "~A ~A" (lisp-implementation-type) (lisp-implementation-version)))
       (:li (format s "Hunchentoot ~A" hunchentoot::*hunchentoot-version*))
       (:li (format s "CL-WHO")))
      (:div
       (:a :href "static/lisp-glossy.jpg" (:img :src "static/lisp-glossy.jpg" :width 100)))
      (:div
       (:a :href "static/hello.txt" "hello"))
      ;;(:h3 "App Database")
      ;;(:div
       ;;(:pre "SELECT version();"))
      ;;(:div (format s "~A" (postmodern:with-connection (db-params)
	;;		     (postmodern:query "select version()"))))
      ))))
