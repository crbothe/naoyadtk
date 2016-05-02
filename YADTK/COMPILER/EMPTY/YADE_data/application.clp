
; Write here some CLIPS user-functions:

(deffunction MAIN::foo (?x ?y)
	(return (+ ?x ?y)))

; Some user-functions can be written in Python:

(deffunction MAIN::bar (?str)) ; This function is defined in the file application.py
