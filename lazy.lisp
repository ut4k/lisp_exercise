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
