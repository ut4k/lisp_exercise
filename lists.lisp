;;再確認 lispのリストはコンスセルの連なりである
(cons 1 (cons 2 (cons 3 nil)))

;;リストの終端がnil以外で終わっているものはドットリストと呼ばれる
(cons 1 (cons 2 3))

(cons 2 3)

;;循環リストの取扱をONにする
;;ONにしないとスタックオーバーフローやら無限ループがおきる
(setf *print-circle* t)

(defparameter foo (list 1 2 3))
;;最後のnilをリストの先頭を指すように書き換える
(setf (cdddr foo) foo)

;;'(1 2 3 1 2 3 1 2 3 ...)


;;連想リスト alist
(defparameter *drink-order* '((bill . double-espresso)
			      (lisa . small-drip-coffee)
			      (john . medium-latte)))
;;あるキーの場所を見る
(assoc 'lisa *drink-order*)

;;あるキーの値を上書き。新しい要素を追加する関数だが、キーがすでにあるので上書きできる。
(push '(lisa . large-mocha-with-shipped-cream) *drink-order*)

;;木構造
(defparameter *house* '((walls (mortar (cement)
				(water)
				(sand))
			 (bricks))
			(windows (glass)
			 (frame)
			 (curtains))
			(roof (shingles)
			 (chimney))))

;;グラフを書く Graphvizで
(defun dot-name (exp)
  (substitute-if #\_ (complement #'alphanumericp) (prin1-to-string exp)))

(substitute-if 0 #'oddp '(1 2 3 4 5 6 7 8))

;;ラベルを生成
(defparameter *max-label-length* 30)
(defun dot-label (exp)
  (if exp
      (let ((s (write-to-string exp :pretty nil)))
	(if (> (length s) *max-label-length*)
	(concatenate 'string (subseq s 0 (- *max-label-length* 3)) "...")
	s))
      ""))

(defun nodes->dot (nodes)
  (mapc (lambda (node)
	  (fresh-line)
	  (princ (dot-name (car node)))
	  (princ "[label=\"")
	  (princ (dot-label node))
	  (princ "\"];"))
	nodes))

;;魔法使いの館のノード
(defparameter *wizard-nodes* '((living-room (you are in the living-room.
					     a wizard is snoring loudly on the couch.))
			       (garden (you are in a beautiful garden.
					there is a well in front of you.))
			       (attic (you are in the attic. there is a giant welding torch in the corner.))))

(defparameter *wizard-edges* '((living-room (garden west door)
				(attic upstairs ladder))
			       (garden (living-room east door))
			       (attic (living-room downstairs ladder))))

;;エッジをDOTのフォーマットに変換する
(defun edges->dot (edges)
  (mapc (lambda (node)
	  (mapc (lambda (edge)
		  (fresh-line)
		  (princ (dot-name (car node)))
		  (princ "->")
		  (princ (dot-name (car edge)))
		  (princ "[label=\"")
		  (princ (dot-label (cdr edge)))
		  (princ "\"];"))
		(cdr node)))
	edges))

;;dot変換
(defun graph->dot (nodes edges)
  (princ "digraph{")
  (nodes->dot nodes)
  (edges->dot edges)
  (princ "}"))

;;dotを画像にする
(defun dot->png (frame thunk)
  (with-open-file (*standard-output*
		   fname
		   :direction :output
		   :if-exists :supersede)
    (funcall thunk))
  (ext:shell (concatenate 'string "dot -Tpng -O " fname)))

;;ファイル出力
(with-open-file (my-stream
		 "testfile.txt"
		 :direction :output
		 :if-exists :supersede)
		(princ "Hello File!" my-stream))

;;グラフを画像に
(defun graph->png (fname nodes edges)
  (dot->png fname
	    (lambda ()
	      (graph->dot nodes edges))))






