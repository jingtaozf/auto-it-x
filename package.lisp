;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-
;; 
;; Filename: package.lisp
;; Description: package definition.
;; Author: Xu Jingtao
;; Created: 2010.09.14 23:00:36(+0800)
;; Last-Updated: 2010.09.14 17:31:30(+0800)
;;     Update #: 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :common-lisp-user)
(defpackage :auto-it-x 
  (:nicknames "AU3" "AU")
  (:use :cl :arnesi #+lispworks :capi)
  (:shadow #:error #:sleep)
  (:documentation "auto-it-x wrapper in common lisp"))
