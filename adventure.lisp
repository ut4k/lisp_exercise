(defparameter *nodes* '((living-room (you are in the living-room.
				      a wizard is snoring loudly on the couch.))
			(garden (you are in a beautiful garden. there is a well in front of you.))
			(attic (you are in the attic. there is a giant welding torch in the corner.))))

;; リストの中からキーで要素を取り出す assoc
(assoc 'garden *nodes*)

;;場所を描画する関数
(defun describe-location (location nodes)
  (cadr (assoc location nodes)))

;; エッジの構造
(defparameter *edges* '((living-room (garden west door)
			 (attic upstairs ladder))
			(garden (living-room east door))
			(attic (living-room downstairs ladder))))

;;エッジから説明を得る関数
(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))

;; 複数の通り道を描画する
(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

;; オブジェクトのリスト
(defparameter *objects* '(whiskey bucket frog chain))

;;オブジェクトの場所
(defparameter *object-locations* '((whiskey living-room)
				   (bucket living-room)
				   (chain garden)
				   (frog garden)))

;;オブジェクトの場所をとりだす
(defun objects-at (loc objs obj-locs)
  (labels ((at-loc-p (obj)
	     (eq (cadr (assoc obj obj-locs)) loc)))
    (remove-if-not #'at-loc-p objs)))

;;見えるオブジェクトを描画
(defun describe-objects (loc objs obj-loc)
  (labels ((describe-obj (obj)
	     `(you see a ,obj on the floor.)))
    (apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc)))))

;;現在地
(defparameter *location* 'living-room)

;;みわたす
;;グローバル変数*location*を見てるので関数としては汚い
(defun look ()
  (append (describe-location *location* *nodes*)
	  (describe-paths *location* *edges*)
	  (describe-objects *location* *objects* *object-locations*)))

;;うごく
(defun walk (direction)
  (let ((next (find direction
		    (cdr (assoc *location* *edges*))
		    :key #'cadr)))
    (if next
	(progn (setf *location* (car next))
	       (look))
	'(you cannot go that way.))))

;;オブジェクトを手に取る
(defun pickup (object)
  (cond ((member object
		 (objects-at *location* *objects* *object-locations*))
	 (push (list object 'body) *object-locations*)
	 `(you are now carrying the ,object))
	(t '(you cannot get that.))))

;;もっているものを調べる
(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))
