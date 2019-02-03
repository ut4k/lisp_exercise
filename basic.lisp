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

;; ifコマンド (ifも制御構文じゃなくてコマンドなのか!?)
;; ifは条件の中で一個のことしかできない
(princ (if (= (+ 1 2) 3)
    'yup
    'nope))

(princ (if (= (+ 1 2) 4)
	   'yup
	   'nope))

;; when と unless
;; whenは条件が真のときに複数のことをできる
(defvar *number-is-odd* nil)
(princ (when (oddp 5)
  (setf *number-is-odd* t)
  'odd-number))

;; unlesssは条件が偽のときに複数のことをできる

(unless (oddp 4)
  (setf *number-is-odd* nil)
  'even-number)

;; condで分岐　上から下にマッチングを見ていってマッチした行を実行
(defvar *arch-enemy* nil)

(defun pudding-eater (person)
  (cond ((eq person 'henry) (setf *arch-enemy* 'stupid-lisp-alien)
                           '(curse you lisp alien - you ate my pudding))
        ((eq person 'johnny) (setf *arch-enemy* 'useless-old-johnny)    
                           '(i hope you choked on my pudding johnny))
	 (t                '(why you eat my pudding stranger ?)))) 

;; こっちはcase
(defun pudding-eater2 (person)
  (case person
    ((henry) (setf *arch-enemy* 'stupid-lisp-alien)
     '(curse you lisp alien - you ate my pudding))
    ((johnny) (setf *arch-enemy* 'useless-old-johnny)
     '(i hope you chocked on my pudding johnny))
    (otherwise '(why you eat my pudding stranger?))))

;; and or
(and (oddp 5) (oddp 7) (oddp 9))
;; --> T

(or (oddp 4) (oddp 7) (oddp 8))
;; --> T

;; 真偽以上のものを返す関数     
(if (member 1 '(3 4 1 5))
    'one-is-in-the-list
    'one-is-not-in-the-list)

;;memberがなぜ部分リストを返すか
(if (member nil '(3 4 1 5))
    'nil-is-in-the-list
    'nil-is-not-in-the-list)

;;この関数が実行されたときにnilが見つかってもmemberがnilを返せばそれは偽であると評価されて、結果がおかしくなってしまうから

;;find-if
;;第一引数に「述語」になる関数をうけとってそれをマップするのかな?
(find-if #'oddp '(2 4 5 6))
;; --> 5


;;eqとその仲間たち

;;シンボル同士はeqをつかう
(defparameter *fruit* 'apple)
(cond ((eq *fruit* 'apple) 'its-an-apple)
      ((eq *fruit* 'orange) 'its-an-orange))

 
;;シンボル同士でなければequalをつかう
(equal 'apple 'apple)
(equal (list 1 2 3) (list 1 2 3))

;;eql
;;equalp
;;というのもある
     
