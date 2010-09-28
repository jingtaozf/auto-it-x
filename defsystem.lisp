;;; -*- encoding:utf-8; Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-
;; 
;; Filename: defsystem.lisp
;; Description: defsystem of auto-it-x.
;; Author: Xu Jingtao
;; Created: 2010.09.14 13:00:36(+0800)
;; Last-Updated: 2010.09.15 15:22:41(+0800)
;;     Update #: 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :cl-user)
(defparameter *auto-it-x-base-directory*
  (make-pathname :name nil :type nil :version nil
                 :defaults (asdf:component-pathname (asdf:find-system "auto-it-x"))))
(defparameter *auto-it-x-obj-directory*
  (merge-pathnames
   #P"objs/"
   (make-pathname :name nil :type nil :version nil
                  :defaults (asdf:component-pathname (asdf:find-system "auto-it-x")))))

(defsystem auto-it-x
  (:default-pathname *auto-it-x-base-directory*
      :default-type :lisp-file
      :object-pathname *auto-it-x-obj-directory*)
  :members ("package"
            "fli"
            "wrapper")
  :rules ((:in-order-to :compile :all
                        (:requires (:load :previous)))
          (:in-order-to :load :all
                        (:requires (:load :previous)))))
