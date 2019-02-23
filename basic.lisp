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
     

;;データ構造

;;配列
(make-array 3)

(defparameter x (make-array 3))
;; arefで取り出す
(aref x 1)

(setf (aref x 1) 'foo)

;;setfは値を入れるときにも取り出すときにも書ける
(setf foo (list 'a 'b 'c))
(setf (second foo) 'z)

;;setfの最初の引数は汎変数(generalized variable)と呼ばれる
(setf (aref foo 2) (list 'x 'y 'z))

;;ハッシュテーブル -- alistと似てる
(defparameter x (make-hash-table))
;;ハッシュテーブルの値はgethashで取り出す
(gethash 'yup x)
;;注)gethashは値を複数返す common lispは値を複数返せる機能がある。（リストというわけじゃない）
;;配列と同じくsetfで値を保存できる
(setf (gethash 'yup x) '25)
(gethash 'yup x)
;; 25 <-- 保存されている値
;; T  <-- 存在したかどうか

;;値を複数返す関数を自作する
;;valuesを使う
(defun foo()
  (values 3 7))

(+ (foo) 5)
;;8　がかえる　つまり１つ目の値3だけが使われたということ 3+5=8

;;もし２番めの値がほしいときはmultiple-value-bindを使う
(multiple-value-bind (a b) (foo)
  (* a b))
;;21

;;構造体
(defstruct person
  name
  age
  waist-size
  favorite-color)

;;構造体を作ると自動で make-構造体の名前の関数が使えるようになる
;;personの場合make-person

;;インスタンスもつくれる!
(defparameter *bob* (make-person :name "Bob"
				 :age 35
				 :waist-size 32
				 :favorite-color "blue"))

;;構造体にアクセスするには 構造体の名前-スロットの名前の関数を使う
;;これも自動で使えるようになる
(person-age *bob*)

;;これもまたもやsetfで構造体の値を買えられる
(setf (person-age *bob*) 36)

;;defstructしただけでインスタンス作成用の関数や、アクセス用の関数が使えるようになり非常に強力!

;;-----データをジェネリックに扱う-----

;;シーケンス関数はいろんなデータ型に使える
(length '(a b c))
(length "blub")
(length (make-array 5))

(find-if #'numberp '(a b 5 d))
(count #\s "mississippi")
(position #\4 "2kewl4skewl")
(some #'numberp '(a b 5 d))
(every #'numberp '(a b 5 d))

(reduce #'+ '(3 4 6 5 2))

(reduce (lambda (best item)
	  (if (and (evenp item) (> item best))
	      item
	      best))
	'(7 4 6 5 2)
	:initial-value 0)

;;reduceで要素の和を求める関数を書いてみる
(defun sum (lst)
  (reduce #'+ lst))

(sum '(1 2 3))
(sum (make-array 5 :initial-contents '(1 2 3 4 5)))
;;(sum "blablabla") ;; これはエラー　文字列の加算はできない。。。


;;mapcarと別にすべてのシーケンスに使えるmapもやっぱり用意されている
;;mapcarはリスト専用
(map 'list
     (lambda (x)
       (if (eq x #\s)
	   #\S
	   x))
     "this is a string")

(subseq "america" 2 6)

(sort '(5 8 2 4 9 3 6) #'<)


;;ジェネリック関数を自分で書いてみる

;;arrayp, characterp, consp, functionp, hash-table-p, listp, stringp, symbolp
;;などの型述語を使えば変数が特定のデータ型をもっているか調べられる

(defun add (a b)
  (cond ((and (numberp a) (numberp b)) (+ a b))
	((and (listp a) (listp b)) (append a b))))
;;この関数には問題が多い・・・
