;let1マクロを作る
(defmacro let1 (var val &body body)
  `(let ((,var ,val))
     ,@body))

;letはカッコが多くて冗長なのでlet1でかけば完結
(let ((foo (+ 2 3)))
  (* foo foo))


(let1 foo (+ 2 3)
      (* foo foo))

			;リストの長さを数える関数my-length
;これは冗長
;; (defun my-length (lst)
;;   (labels ((f (lst acc)
;; 	     (if lst
;; 		 (f (cdr lst) (1+ acc))
;; 		 acc)))
;;     (f lst 0)))

					;splitマクロを作る リストを分割
;バグあり
;; (defmacro split (val yes no)
;;   `(if ,val
;;        (let ((head (car ,val))
;; 	     (tail (cdr ,val)))
;; 	 ,yes)
;;        ,no))


					;my-lengthをsplitを使ってきれいに
;; (defun my-length (lst)
;;   (labels ((f (lst acc)
;; 	     (split lst
;; 		    (f tail (1+ acc))
;; 		    acc)))
;;     (f lst 0)))


					;その2
;; (defmacro split (val yes no)
;;   `(let1 x ,val
;;      (if x
;; 	 (let ((head (car x))
;; 	       (tail (cdr x)))
;; 	   ,yes)
;; 	 ,no)))

;;もし変数xを渡してしまうと衝突する
;;ユニークな名前を生成するgensymをつかうべき

(defmacro split (val yes no)
  (let1 g (gensym)
    `(let1 ,g ,val
       (if ,g
	   (let ((head (car ,g))
		 (tail (cdr ,g)))
	     ,yes)
	   ,no))))


;; (defun my-length (lst)
;;   (labels ((f (lst acc)
;; 	     (split lst
;; 		    (f tail (1+ acc))
;; 		    acc)))
;;     (f lst 0)))

(defun pairs (lst)
  (labels ((f (lst acc)
	     (split lst
		    (if tail
			(f (cdr tail) (cons (cons head (car tail)) acc))
		    (reverse acc))
	     (reverse acc))))
    (f lst nil)))

;;マクロrecurse
(defmacro recurse (vars &body body)
  (let1 p (pairs vars)
    `(labels ((self ,(mapcar #'car p)
		,@body))
       (self ,@(mapcar #'cdr p)))))

(defun my-length (lst)
  (recurse (let lst
	     acc 0)
	   (split lst
		  (self tail (1+ acc))
		  acc)))

;;マクロは自分の方言を作ってしまうため他人がコードを読みづらくなる
;;パターンを想定してデバッグしておかないと危なすぎる
