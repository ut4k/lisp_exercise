(load "inc.lisp")
(foo)

;; 前の定義を消すにはこれ fmakunbound
(fmakunbound 'foo)
(defun foo () 20)
