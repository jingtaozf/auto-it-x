;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-  --- 
;; 
;; Filename: t.lisp
;; Description: test codes of auto-it-x
;; Author: Xu Jingtao
;; Created: 2010.09.14 20:26:25(+0800)
;; Last-Updated: 2010.09.14 20:52:57(+0800)
;;     Update #: 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :auto-it-x)
(defun test-notepad ()
  (sleep 1000)
  (run "notepad.exe")
  (win-wait-active "无标题 - 记事本")
  (send "Hello{!}"))

(defun test-calculator ()
  (run "calc.exe")
  (win-wait-active "计算器")
  (send "2*2=")
  (sleep 500)
  (send "4*4=")
  (sleep 500)
  (send "8*8=")
  (sleep 500)
  (win-close "计算器")
  (win-wait-close "计算器"))
