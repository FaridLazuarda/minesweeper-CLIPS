(deftemplate board
    (slot size
        (type INTEGER)
        (default 10)
    )
    (slot remaining-bomb
        (type INTEGER)
        (default 10)
    )
)

(deftemplate square
    (slot is-open
        (type INTEGER)
        (allowed-integers 0 1)
        (default 0) ;0 false 1 true
    )
    (slot x
        (type INTEGER)
        (default 0)
    )
    (slot y
        (type INTEGER)
        (default 0)
    )
    (slot is-flag
        (type INTEGER)
        (allowed-integers 0 1)
        (default 0) ;0 false 1 true
    )
    (slot angka
        (type INTEGER)
        (range -1 8)
        (default 0) ; -1 berarti bomb
    )
    (slot closed-square-around
        (type INTEGER)
        (range 0 8)
        (default 0)
    )
)

; K -> Kosong
; B -> Bo

; K | 2 | B
; K | 3 | B
; 1 | B | K

; (deffacts initial-dummy
;     (board (size 3) (remaining-bomb 3))
;     (square (is-open 0) (x 0) (y 0) (is-flag 0) (angka 0) (closed-square-around 3))
;     (square (is-open 0) (x 0) (y 1) (is-flag 0) (angka 2) (closed-square-around 5))
;     (square (is-open 0) (x 0) (y 2) (is-flag 0) (angka -1) (closed-square-around 3))
;     (square (is-open 0) (x 1) (y 0) (is-flag 0) (angka 2) (closed-square-around 5))
;     (square (is-open 0) (x 1) (y 1) (is-flag 0) (angka 4) (closed-square-around 8))
;     (square (is-open 0) (x 1) (y 2) (is-flag 0) (angka -1) (closed-square-around 5))
;     (square (is-open 0) (x 2) (y 0) (is-flag 0) (angka -1) (closed-square-around 3))
;     (square (is-open 0) (x 2) (y 1) (is-flag 0) (angka -1) (closed-square-around 5))
;     (square (is-open 0) (x 2) (y 2) (is-flag 0) (angka 2) (closed-square-around 3))
; )

; K | 1 | B
; K | 2 | 2
; K | 1 | B

(deffacts initial-dummy-2
    (board (size 3) (remaining-bomb 3))
    (square (is-open 0) (x 0) (y 0) (is-flag 0) (angka 0) (closed-square-around 3))

    (square (is-open 0) (x 0) (y 1) (is-flag 0) (angka 1) (closed-square-around 5))

    (square (is-open 0) (x 0) (y 2) (is-flag 0) (angka -1) (closed-square-around 3))

    (square (is-open 0) (x 1) (y 0) (is-flag 0) (angka 0) (closed-square-around 5))

    (square (is-open 0) (x 1) (y 1) (is-flag 0) (angka 2) (closed-square-around 8) (remaining-subtract-others 8))

    (square (is-open 0) (x 1) (y 2) (is-flag 0) (angka 2) (closed-square-around 5))

    (square (is-open 0) (x 2) (y 0) (is-flag 0) (angka 0) (closed-square-around 3))

    (square (is-open 0) (x 2) (y 1) (is-flag 0) (angka 1) (closed-square-around 5))

    (square (is-open 0) (x 2) (y 2) (is-flag 0) (angka -1) (closed-square-around 3))
)

(defrule initialize
    ?init <- (square (is-open 0) (x 0) (y 0))
=>
    (printout t "Game Start!" crlf)
    (modify ?init (is-open 1))
)

(defrule open-surrounding-square
    (declare (salience 100)) ; Naikin prioritas
    (square (is-open 1) (x ?x1) (y ?y1) (angka 0)) ; Kalo square yang terbuka
    ?open-square <- (square (is-open 0) (x ?x2) (y ?y2))
    (test (>= 1 (abs (- ?x2 ?x1))))
    (test (>= 1 (abs (- ?y2 ?y1))))
=>
    (modify ?open-square (is-open 1))
)

; (defrule open-right-box
;     (declare (salience 100)) ; Naikin prioritas
;     (square (is-open 1) (x ?x1) (y ?y1)) ; Kalo square yang terbuka
;     ?open-box <- (square (is-open 0) (x ?x2) (y ?y2))
;     (test (= ?x2 (+ ?x1 1)))
;     (test (= ?y2 ?y1))
; =>
;     (printout t "Buka square kanan!" crlf)
;     (modify ?open-box (is-open 1))
; )

; (defrule open-bottom-right-box
;     (declare (salience 100)) ; Naikin prioritas
;     (square (is-open 1) (x ?x1) (y ?y1)) ; Kalo square yang terbuka
;     ?open-box <- (square (is-open 0) (x ?x2) (y ?y2))
;     (test (= ?x2 (+ ?x1 1)))
;     (test (= ?y2 (- ?y1 1)))
; =>
;     (printout t "Buka square kanan bawah!" crlf)
;     (modify ?open-box (is-open 1))
; )

; (defrule open-bottom-box
;     (declare (salience 100)) ; Naikin prioritas
;     (square (is-open 1) (x ?x1) (y ?y1)) ; Kalo square yang terbuka
;     ?open-box <- (square (is-open 0) (x ?x2) (y ?y2))
;     (test (= ?x2 ?x1))
;     (test (= ?y2 (- ?y1 1)))
; =>
;     (printout t "Buka square bawah!" crlf)
;     (modify ?open-box (is-open 1))
; )

; (defrule open-bottom-left-box
;     (declare (salience 100)) ; Naikin prioritas
;     (square (is-open 1) (x ?x1) (y ?y1)) ; Kalo square yang terbuka
;     ?open-box <- (square (is-open 0) (x ?x2) (y ?y2))
;     (test (= ?x2 (- ?x1 1)))
;     (test (= ?y2 (- ?y1 1)))
; =>
;     (printout t "Buka square kiri bawah!" crlf)
;     (modify ?open-box (is-open 1))
; )

; (defrule open-left-box
;     (declare (salience 100)) ; Naikin prioritas
;     (square (is-open 1) (x ?x1) (y ?y1)) ; Kalo square yang terbuka
;     ?open-box <- (square (is-open 0) (x ?x2) (y ?y2))
;     (test (= ?x2 (- ?x1 1)))
;     (test (= ?y2 ?y1))
; =>
;     (printout t "Buka square kiri!" crlf)
;     (modify ?open-box (is-open 1))
; )

; (defrule open-top-left-box
;     (declare (salience 100)) ; Naikin prioritas
;     (square (is-open 1) (x ?x1) (y ?y1)) ; Kalo square yang terbuka
;     ?open-box <- (square (is-open 0) (x ?x2) (y ?y2))
;     (test (= ?x2 (- ?x1 1)))
;     (test (= ?y2 (+ ?y1 1)))
; =>
;     (printout t "Buka square kiri atas!" crlf)
;     (modify ?open-box (is-open 1))
; )