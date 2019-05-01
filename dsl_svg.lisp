;;前に作ったpairs関数を読み込む
(load "macro.lisp")

(defun print-tag (name alst closingp)
   (princ #\<)
  (when closingp
    (princ #\/))
  (princ (string-downcase name))
  (mapc (lambda (att)
	  (format t " ~a=\"~a\"" (string-downcase (car att)) (cdr att)))
	alst)
  (princ #\>))

(defmacro tag (name atts &body body)
  `(progn (print-tag ',name
		     (list ,@(mapcar (lambda (x)
					`(cons ',(car x) ,(cdr x)))
				      (pairs atts)))
		     nil)
	  ,@body
	  (print-tag ',name nil t)))


;;svgマクロ
(defmacro svg (width height &body body)
  `(tag svg (xmlns "http://www.w3.org/2000/svg"
		   "xmlns:xlink" "http://www/w3/org/1999/xlink" height ,height width ,width)
     ,@body))

;;色生成
(defun brightness (col amt)
  (mapcar (lambda (x)
	    (min 255 (max 0 (+ x amt))))
	  col))

;;svgのスタイル生成
(defun svg-style (color)
  (format nil
	  "~{fill:rgb(~a,~a,~a);stroke:rgb(~a,~a,~a)~}"
	  (append color
		  (brightness color -100))))

;;円を書く
(defun circle (center radius color)
  (tag circle (cx (car center)
		  cy (cdr center)
		  r radius
		  style (svg-style color))))

;;多角形を書く
(defun polygon (points color)
  (tag polygon (points (format nil
			       "~{~a,~a ~}"
			       (mapcan (lambda (tp)
					 (list (car tp) (cdr tp)))
				       points))
		       style (svg-style color))))

;;ランダムウォークを書く
(defun random-walk (value length)
  (unless (zerop length)
    (cons value
	  (random-walk (if (zerop (random 2))
			   (1- value)
			   (1+ value))
		       (1- length)))))
		  
