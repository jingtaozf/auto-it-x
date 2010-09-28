;;;; -*- encoding:utf-8; Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;; 
;; Filename: auto-it-x.asd
;; Description: asd definition.
;; Author: Xu Jingtao
;; Created: 2010.09.14 13:00:36(+0800)
;; Last-Updated: 2010.09.14 21:07:40(+0800)
;;     Update #: 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(asdf:defsystem auto-it-x-test
  :author "Xu Jingtao <jingtaozf@gmail.com>"
  :version "0.1"
  :serial t
  :description "autoItX wrapper in common lisp "
  :components ((:module test :pathname "./"
						:components ((:file "t"))
                        :serial t))
  :properties ((version "0.1"))
  :depends-on (:auto-it-x))

