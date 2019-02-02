;; 関数は(関数名 (引数))でつかう
;; (コマンド (引数　引数 ...))としてつかい、このカッコ全体はフォームと呼ぶ
(princ (+ 1 (* 1 10)))

;; ローカル変数定義はlet
(princ (let ((a 10)
      (b 20))
	 (+ a b)))

;; ローカル関数定義はflet
(flet ((f (n)
	 (+ n 10)))
  (f 5))

;; labelsはfletとにているが、こちらは再帰ができる
(labels ((a (n)
	   (+ n 5))
	 (b (n)
	   (+ (a n) 6)))
  (b 10))

;; cons -- 要素を一個のリストに合体する(construct)
(cons 'chicken 'cat)
(cons 'chicken 'nil)
(cons 'chicken ())
(cons 'pork(cons 'beef (cons 'chicken ())))

;; car -- カー Haskellのfst
(car '(pork beef chicken))
;; cdr -- クダー could-er Haskellのsnd
(cdr '(pork beef chicken))
;; list --コンスセルをまとめてつくる
(list 'pork 'beef 'chicken)

;; 再帰でリストの長さを調べる
(defun my-length (list)
  (if list
      (1+ (my-length (cdr list)))
      0))
