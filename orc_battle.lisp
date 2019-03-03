;;プレイヤー体力、素早さ、力
(defparameter *player-health* nil)
(defparameter *player-agility* nil)
(defparameter *player-strength* nil)
;;モンスター設定
(defparameter *monsters* nil)
(defparameter *monster-builders* nil)
(defparameter *monster-num* 12)

;;ゲームのメイン関数
(defun orc-battle ()
  (init-monsters) ;;モンスター初期化
  (init-player) ;;プレイヤー初期化
  (game-loop) ;;ゲームループ
  (when (player-dead) ;;プレイヤー死亡 : ゲームオーバー
    (princ "You have been killed. Game Over."))
  (when (monsters-dead) ;; モンスター死亡 : ゲームクリア
    (princ "Congratulations! You have vanquished all of your foes.")))

;;ゲームループ
(defun gameloop ()
  (unless (or (player-dead) (monsters-dead))
    (show-player)
    ;;dotimesコマンド : 変数と数値をうけとり、本体をn回繰り返す
    (dotimes (k (1+ (trancate (/ (max 0 *player-agility*) 15))))
      (unless (monsters-dead)
	(show-monsters)
	(player-attack)))
    (fresh-line)
    (map 'list
	 (lambda (m)
	   (or (monster-dead m) (monster-attack m)))
	 *monsters*)
    (game-loop)))

;;プレイヤー管理
(defun init-player ()
  (setf *player-health* 30)
  (setf *player-agility* 30)
  (setf *player-strength* 30))

;;プレイヤー死亡
;;プレイヤーのヘルスが0以下であるかの真偽を返す
(defun player-dead ()
  (<= *player-health* 0))

;;プレイヤー状態表示
(defun show-player ()
  (fresh-line)
  (princ "You are a valiant knight with a health of ")
  (princ *player-health*)
  (princ ", an agility of ")
  (princ *player-agility*)
  (princ ", and a strength of ")
  (princ *player-strength*))

;;攻撃
(defun player-attack ()
  (fresh-line)
  (princ "Attack style: [s]tab [d]ouble swing [r]oundhouse:")
  (case (read)
    (s (monster-hit (pick-monster)
		    (+2 (randval (ash *player-strength* -1)))))
    (d (let ((x (randval (truncate (/ *player-strength* 6)))))
	 (princ "Your double swing has a strength of ")
	 (princ x)
	 (fresh-line)
	 (monster-hit (pick-monster) x)
	 (unless (monsters-dead)
	   (monster-hit (pick-monster) x)))
       (otherwise (dotimes (x (1+ (randval (truncate (/ *player-strength* 3)))))
		    (unless (monsters-dead)
		      (monster-hit (random-monster) 1)))))))



(defun randval (n)
  (1+ (random (max 1 n))))

(defun random-monster ())
