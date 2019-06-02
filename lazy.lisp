;;遅延評価を実装する
(defmacro lazy (&body body)
  (let ((forced (gensym))
	(value (gensym)))
  `(let ((,forced nil)
	 (,value nil))
     (lambda ()
       (unless ,forced
	 (setf ,value (progn ,@body))
	 (setf ,forced t))
       ,value))))

(defun force (lazy-value)
  (funcall lazy-value))

;;遅延リストを実装
(defmacro lazy-cons (a d)
  `(lazy (cons ,a ,d)))

(defun lazy-car (x)
  (car (force x)))

(defun lazy-cdr (x)
  (cdr (force x)))

(defun lazy-nil ()
  (lazy nil))

(defun lazy-null (x)
  (not (force x)))

;;通常リストを遅延リストに
(defun make-lazy (lst)
  (lazy (when lst
	  (cons (car lst) (make-lazy (cdr lst))))))

;;無限リスト
(defparameter *integers*
  (labels ((f (n)
	     (lazy-cons n (f (1+ n)))))
    (f 1)))

;;遅延リストを通常リストに（↑の逆）
(defun take (n lst)
  (unless (or (zerop n) (lazy-null lst))
    (cons (lazy-car lst) (take (1- n) (lazy-cdr lst)))))

(defun take-all (lst)
  (unless (lazy-null lst)
    (cons (lazy-car lst) (take-all (lazy-cdr lst)))))

;;遅延版map関数

(defun lazy-mapcar (fun lst)
  (lazy (unless (lazy-null lst)
	  (cons (funcall fun (lazy-car lst))
		(lazy-mapcar fun (lazy-cdr lst))))))

(defun lazy-mapcan (fun lst)
  (labels ((f (lst-cur)
	     (if (lazy-null lst-cur)
		 (force (lazy-mapcan fun (lazy-cdr lst)))
		 (cons (lazy-car lst-cur) (lazy (f (lazy-cdr lst-cur)))))))
    (lazy (unless (lazy-null lst)
	    (f (funcall fun (lazy-car lst)))))))

(defun lazy-find-if (fun lst)
  (unless (lazy-null lst)
    (let ((X (lazy-car lst)))
      (if (funcall fun x)
	  x
	  (lazy-find-if fun (lazy-cdr lst))))))

(defun lazy-nth (n lst)
  (if (zerop n)
      (lazy-car lst)
      (lazy-nth (1- n) (lazy-cdr lst))))
