;;;; -*- encoding:utf-8; Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;; 
;; Filename: auto-it-x.asd
;; Description: asd definition.
;; Author: Xu Jingtao
;; Created: 2010.09.14 13:00:36(+0800)
;; Last-Updated: 2010.09.15 15:22:29(+0800)
;;     Update #: 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :auto-it-x.system)
    (defpackage :auto-it-x.system
      (:use :cl))))
(in-package :auto-it-x.system)

(asdf:defsystem auto-it-x
  :author "Xu Jingtao <jingtaozf@gmail.com>"
  :version "0.1"
  :serial t
  :description "autoItX wrapper in common lisp "
  :components ((:module basics :pathname "./"
						:components ((:file "package")
                                     #+lispworks(:file "defsystem"))
                        :serial t)
			   (:module misc :pathname "./"
                        ;;interface with Taotbao Open Platform
						:depends-on (basics)
                        :components ((:file "fli")
                                     (:file "wrapper"))
                        :serial t))
  :properties ((version "0.1"))
  :depends-on (:arnesi))

