(with-open-file (my-stream "data.txt" :direction :output)
  (print "my data" my-stream))

(let ((animal-noises '((dog . woof)
			(cat . meow))))
      (with-open-file (my-stream "animal-noises.txt" :direction :output)
	(print animal-noises my-stream)))

(with-output-to-string (*standard-output*)
  (princ "the sum of ")
  (princ 5)
  (princ " and ")
  (princ 2)
  (princ " is ")
  (princ (+ 2 5)))