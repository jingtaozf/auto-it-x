;;; -*- encoding:utf-8 Mode: LISP; Syntax: COMMON-LISP; Base: 10  -*-  --- 
;; 
;; Filename: fli.lisp
;; Description: foreign language interface definition.
;; Author: Xu Jingtao
;; Created: 2010.09.14 13:51:06(+0800)
;; Last-Updated: 2010.09.16 19:47:59(+0800)
;;     Update #: 72
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :auto-it-x)
(eval-always
  (defconstant +DEFAULT-BUFFER-SIZE+ 512 "\"default\" buffer size passed to c function")
  (defun char-upcase-p (char)
    (char<= #\A char #\Z))
  (defun convert-c-name-to-lisp-name (name)
    "convert a c style name to lisp style name"
    (if (or (string= "AU3_" (subseq name 0 4))
            (string= "AU3-" (subseq name 0 4)))
      (setf name (subseq name 4)))
    (with-output-to-string (s)
      (princ (char-upcase (aref name 0)) s)
      (loop for i from 1 to (1- (length name))
         for prev = (aref name (1- i))
         for curr = (aref name i)
         do (cond ((char= curr #\_)
                   (princ #\- s))
                  ((char-upcase-p curr)
                   (if (and (char/= prev #\-)
                            (char/= prev #\_)
                            (not (char-upcase-p prev)))
                     (princ #\- s))
                   (princ (char-upcase curr) s))
                  (t (princ (char-upcase curr) s))))))

  (defmacro define-au3-api (fli-name result-type &rest parameters)
    `(prog1 
       (fli:define-foreign-function (,(intern (convert-c-name-to-lisp-name fli-name)) ,fli-name)
           ,parameters
         :result-type ,result-type :calling-convention :stdcall :module 'auto-it-x)
       (export '(,(intern (convert-c-name-to-lisp-name fli-name)))))))

(defconstant AU3_INTDEFAULT	-2147483647 "\"Default\" value for _some_ int parameters (largest negative number)")
(fli:define-c-struct tagpoint
    (x :long) (y :long))
(fli:define-c-typedef point (:struct tagpoint))
(fli:define-c-typedef lppoint (:pointer point))
(fli:define-c-typedef lppoint2 (:reference-return point))
(fli:define-c-typedef lpwstr (:reference-return (:ef-wc-string :limit +DEFAULT-BUFFER-SIZE+ :external-format :unicode)))
(fli:define-c-typedef lpcwstr (:reference-pass (:ef-wc-string :external-format :unicode)))
(fli:define-c-typedef lpcstr (:reference-pass (:ef-mb-string :external-format :gbk)))

(fli:register-module 
 'auto-it-x :file-name (make-pathname :name "AutoItX3" :type "dll" :version nil
                                      :defaults (asdf:component-pathname 
                                                 (asdf:find-system "auto-it-x"))))

(define-au3-api "AU3_Init" :void)
(define-au3-api "AU3_error" :long)
(define-au3-api "AU3_AutoItSetOption" :long 
  (szOption lpcwstr)
  (nValue :long))
(define-au3-api "AU3_BlockInput" :void
  (nValue :long))

(define-au3-api "AU3_CDTray" :long 
  (szDrive lpcwstr)
  (szAction lpcwstr))
(define-au3-api "AU3_ClipGet" :void 
  &optional
  (szClip lpwstr)
  ((nBufSize +DEFAULT-BUFFER-SIZE+) :int))
(define-au3-api "AU3_ClipPut" :void 
  (szClip lpcwstr))
(define-au3-api "AU3_ControlClick" :long 
  (szTitle lpcwstr)
  &optional 
  ((szText "") lpcwstr)
  ((szControl "") lpcwstr)
  ((szButton "left") lpcwstr)
  ((nNumClicks 1) :long) 
  ((nX AU3_INTDEFAULT) :long) ((nY AU3_INTDEFAULT) :long))
(define-au3-api "AU3_ControlCommand" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  (szCommand lpcwstr)
  (szExtra lpcwstr)
  (szResult lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_ControlListView" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  (szCommand lpcwstr)
  (szExtra1 lpcwstr)
  (szExtra2 lpcwstr)
  (szResult lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_ControlDisable" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr))
(define-au3-api "AU3_ControlEnable" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr))
(define-au3-api "AU3_ControlFocus" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr))
(define-au3-api "AU3_ControlGetFocus" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControlWithFocus lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_ControlGetHandle" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  (szRetText lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_ControlGetPosX" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((szControl "") lpcwstr))
(define-au3-api "AU3_ControlGetPosY" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((szControl "") lpcwstr))
(define-au3-api "AU3_ControlGetPosHeight" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((szControl "") lpcwstr))
(define-au3-api "AU3_ControlGetPosWidth" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((szControl "") lpcwstr))
(define-au3-api "AU3_ControlGetText" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  &optional
  ((szControlText "") lpwstr)
  ((nBufSize +DEFAULT-BUFFER-SIZE+) :int))
(define-au3-api "AU3_ControlHide" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr))
(define-au3-api "AU3_ControlMove" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  (nX :long) (nY :long) (nWidth :long) (nHeight :long))
(define-au3-api "AU3_ControlSend" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  (szSendText lpcwstr)
  (nMode :long))
(define-au3-api "AU3_ControlSetText" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  (szControlText lpcwstr))
(define-au3-api "AU3_ControlShow" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr))
(define-au3-api "AU3_ControlTreeView" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szControl lpcwstr)
  (szCommand lpcwstr)
  (szExtra1 lpcwstr)
  (szExtra2 lpcwstr)
  (szResult lpwstr)
  (nBufSize :int))

(define-au3-api "AU3_DriveMapAdd" :void 
  (szDevice lpcwstr)
  (szShare lpcwstr)
  (nFlags :long) 
  (szUser lpcwstr)
  (szPwd lpcwstr)
  (szResult lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_DriveMapDel" :long 
  (szDevice lpcwstr))
(define-au3-api "AU3_DriveMapGet" :void 
  (szDevice lpcwstr)
  (szMapping lpwstr)
  (nBufSize :int))

(define-au3-api "AU3_IniDelete" :long 
  (szFilename lpcwstr)
  (szSection lpcwstr)
  (szKey lpcwstr))
(define-au3-api "AU3_IniRead" :void 
  (szFilename lpcwstr)
  (szSection lpcwstr)
  (szKey lpcwstr)
  (szDefault lpcwstr)
  (szValue lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_IniWrite" :long 
  (szFilename lpcwstr)
  (szSection lpcwstr)
  (szKey lpcwstr)
  (szValue lpcwstr))
(define-au3-api "AU3_IsAdmin" :long)

(define-au3-api "AU3_MouseClick" :long 
  (szButton lpcwstr)
  &optional
  ((nX AU3_INTDEFAULT) :long) ((nY AU3_INTDEFAULT) :long) 
  ((nClicks 1) :long) ((nSpeed 10) :long))
(define-au3-api "AU3_MouseClickDrag" :long 
  (szButton lpcwstr)
  (nX1 :long) (nY1 :long) (nX2 :long) (nY2 :long) (nSpeed :long))
(define-au3-api "AU3_MouseDown" :void 
  (szButton lpcwstr))
(define-au3-api "AU3_MouseGetCursor" :long)
(define-au3-api "AU3_MouseGetPosX" :long)
(define-au3-api "AU3_MouseGetPosY" :long)
(define-au3-api "AU3_MouseMove" :long 
  (nX :long) (nY :long) 
  &optional ((nSpeed 10) :long))
(define-au3-api "AU3_MouseUp" :void 
  (szButton lpcwstr))
(define-au3-api "AU3_MouseWheel" :void 
  (szDirection lpcwstr)
  (nClicks :long))

(define-au3-api "AU3_Opt" :long 
  (szOption lpcwstr)
  (nValue :long))

(define-au3-api "AU3_PixelChecksum" (:unsigned :long)
  (nLeft :long) (nTop :long) (nRight :long) (nBottom :long) (nStep :long))
(define-au3-api "AU3_PixelGetColor" :long 
  (nX :long) (nY :long))
;; this function has a bug when invoke.
(define-au3-api "AU3_PixelSearch" :void
  (nLeft :long) (nTop :long) (nRight :long) (nBottom :long) (nCol :long) 
  (nVar :long) (nStep :long) (pPointResult lppoint2))
(define-au3-api "AU3_ProcessClose" :long 
  (szProcess lpcwstr))
(define-au3-api "AU3_ProcessExists" :long 
  (szProcess lpcwstr))
(define-au3-api "AU3_ProcessSetPriority" :long 
  (szProcess lpcwstr)
  (nPriority :long))
(define-au3-api "AU3_ProcessWait" :long 
  (szProcess lpcwstr)
  (nTimeout :long))
(define-au3-api "AU3_ProcessWaitClose" :long 
  (szProcess lpcwstr)
  (nTimeout :long))
(define-au3-api "AU3_RegDeleteKey" :long 
  (szKeyname lpcwstr))
(define-au3-api "AU3_RegDeleteVal" :long 
  (szKeyname lpcwstr)
  (szValuename lpcwstr))
(define-au3-api "AU3_RegEnumKey" :void 
  (szKeyname lpcwstr)
  (nInstance :long) 
  (szResult lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_RegEnumVal" :void 
  (szKeyname lpcwstr)
  (nInstance :long) 
  (szResult lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_RegRead" :void 
  (szKeyname lpcwstr)
  (szValuename lpcwstr)
  (szRetText lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_RegWrite" :long 
  (szKeyname lpcwstr)
  (szValuename lpcwstr)
  (szType lpcwstr)
  (szValue lpcwstr))
(define-au3-api "AU3_Run" :long 
  (szRun lpcwstr)
  &optional
  ((szDir "") lpcwstr)
  ((nShowFlags 1) :long))
(define-au3-api "AU3_RunAsSet" :long 
  (szUser lpcwstr)
  (szDomain lpcwstr)
  (szPassword lpcwstr)
  (nOptions :int))
(define-au3-api "AU3_RunWait" :long 
  (szRun lpcwstr)
  (szDir lpcwstr)
  (nShowFlags :long))

(define-au3-api "AU3_Send" :void 
  (szSendText lpcwstr)
  &optional
  ((nMode 0) :long))
(define-au3-api "AU3_SendA" :void 
  (szSendText lpcstr)
  (nMode :long))
(define-au3-api "AU3_Shutdown" :long 
  (nFlags :long))
(define-au3-api "AU3_Sleep" :void 
  (nMilliseconds :long))
(define-au3-api "AU3_StatusbarGetText" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (nPart :long) 
  (szStatusText lpwstr)
  (nBufSize :int))

(define-au3-api "AU3_ToolTip" :void 
  (szTip lpcwstr)
  (nX :long) 
  (nY :long))

(define-au3-api "AU3_WinActivate" :void 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr))
(define-au3-api "AU3_WinActive" :long 
  (szTitle lpcwstr)
  (szText lpcwstr))
(define-au3-api "AU3_WinClose" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr))
(define-au3-api "AU3_WinExists" :long 
  (szTitle lpcwstr)
  (szText lpcwstr))
(define-au3-api "AU3_WinGetCaretPosX" :long)
(define-au3-api "AU3_WinGetCaretPosY" :long)
(define-au3-api "AU3_WinGetClassList" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szRetText lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_WinGetClientSizeHeight" :long 
  (szTitle lpcwstr)
  (szText lpcwstr))
(define-au3-api "AU3_WinGetClientSizeWidth" :long 
  (szTitle lpcwstr)
  (szText lpcwstr))
(define-au3-api "AU3_WinGetHandle" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szRetText lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_WinGetPosX" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr))
(define-au3-api "AU3_WinGetPosY" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr))
(define-au3-api "AU3_WinGetPosHeight" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr))
(define-au3-api "AU3_WinGetPosWidth" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr))
(define-au3-api "AU3_WinGetProcess" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szRetText lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_WinGetState" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr))
(define-au3-api "AU3_WinGetText" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szRetText lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_WinGetTitle" :void 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szRetText lpwstr)
  (nBufSize :int))
(define-au3-api "AU3_WinKill" :long 
  (szTitle lpcwstr)
  (szText lpcwstr))
(define-au3-api "AU3_WinMenuSelectItem" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szItem1 lpcwstr)
  (szItem2 lpcwstr)
  (szItem3 lpcwstr)
  (szItem4 lpcwstr)
  (szItem5 lpcwstr)
  (szItem6 lpcwstr)
  (szItem7 lpcwstr)
  (szItem8 lpcwstr))
(define-au3-api "AU3_WinMinimizeAll" :void)
(define-au3-api "AU3_WinMinimizeAllUndo" :void)
(define-au3-api "AU3_WinMove" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (nX :long) (nY :long) (nWidth :long) (nHeight :long))
(define-au3-api "AU3_WinSetOnTop" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (nFlag :long))
(define-au3-api "AU3_WinSetState" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (nFlags :long))
(define-au3-api "AU3_WinSetTitle" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (szNewTitle lpcwstr))
(define-au3-api "AU3_WinSetTrans" :long 
  (szTitle lpcwstr)
  (szText lpcwstr)
  (nTrans :long))

(define-au3-api "AU3_WinWait" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((nTimeout 0) :long))
(define-au3-api "AU3_WinWaitA" :long 
  (szTitle lpcstr)
  &optional
  ((szText "") lpcstr)
  ((nTimeout 0) :long))
(define-au3-api "AU3_WinWaitActive" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((nTimeout 0) :long))
(define-au3-api "AU3_WinWaitActiveA" :long 
  (szTitle lpcstr)
  &optional
  ((szText "") lpcstr)
  ((nTimeout 0) :long))
(define-au3-api "AU3_WinWaitClose" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((nTimeout 0) :long))
(define-au3-api "AU3_WinWaitCloseA" :long 
  (szTitle lpcstr)
  &optional
  ((szText "") lpcstr)
  ((nTimeout 0) :long))
(define-au3-api "AU3_WinWaitNotActive" :long 
  (szTitle lpcwstr)
  &optional
  ((szText "") lpcwstr)
  ((nTimeout 0) :long))
(define-au3-api "AU3_WinWaitNotActiveA" :long 
  (szTitle lpcstr)
  &optional
  ((szText "") lpcstr)
  ((nTimeout 0):long))
