# Land of Lisp の本の内容を学ぶ

ついでにemacsも。

## common lisp

### let

`let`の後ろに`((`とあるときがたまにあるが、  
これは変数名と初期値のペア`(foo 2)`を`let ()`に渡して  
`let ((foo 2))`こんな書き方になっているから。

### defparameter と setf

`defparameter`は基本的にグローバル変数を一回目の定義だけするときにつかうみたい。  
一方`setf`は`defparameter`で決めた変数に代入するような使い方をする。

## emacs用メモ

### slime

#### 起動
`M-x slime`

#### バッファ全体をeval

`C-c C-k`

#### 最後の関数をeval

`C-c C-e`
