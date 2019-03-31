;;コンディションをつくる　 -- エクセプションみたいなもの
(define-condition foo () ()
		 (:report (lambda (condition stream)
			    (princ "Stop FOOing around, numbskull!" stream))))

;;コンディションを横取りする
(defun bad-function ()
  (error 'foo))

(handler-case (bad-function)
  (foo () "somebody signaled foo!")
  (bar () "somebody signaled bar!"))

;;予想外のコンディションからリソースを保護する
(unwind-protect (/ 1 0)
  (princ "I need to say 'flubyduby' matter what"))


