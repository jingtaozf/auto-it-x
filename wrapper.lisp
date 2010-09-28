;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-  --- 
;; 
;; Filename: wrapper.lisp
;; Description: wrapper of foreign language functions.
;; Author: Xu Jingtao
;; Created: 2010.09.15 15:21:41(+0800)
;; Last-Updated: 2010.09.16 14:30:54(+0800)
;;     Update #: 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :auto-it-x)

(defun .pixel-search (left top right bottom col var step)
  (com:co-initialize)
  (let ((obj (com:create-object :progid "AutoItX3.Control")))
    (com:invoke-dispatch-method obj "PixelSearch" left top right bottom col var step)))
