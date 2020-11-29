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
    (slot x
        (type INTEGER)
        (default 0)
    )
    (slot y
        (type INTEGER)
        (default 0)
    )
    (slot is-open
        (type INTEGER)
        (allowed-integers 0 1)
        (default 0) ;0 false 1 true
    )
    (slot is-flag
        (type INTEGER)
        (allowed-integers 0 1)
        (default 0) ;0 false 1 true
    )
    (slot value
        (type INTEGER)
        (range -1 8)
        (default 0) ; -1 is bomb
    )
    (slot closed-square-around ; Surrounding square that has not been opened
        (type INTEGER)
        (range 0 8)
        (default 0)
    )

    (slot flagged-square-around ; Surround square that has been flagged
        (type INTEGER)
        (range 0 8)
        (default 0)
    )

    (multislot subtracted-coordinates-after-open ; List of surrounding coordinates that has been subtracted 1 from its closed-square-around after this square opened
        (type STRING)
        (default "")
    )

    (slot flag-all-around ; Boolean to flag all surrounding square
        (type INTEGER)
        (allowed-integers 0 1)
        (default 0)
    )
    (slot open-all-around ; Boolean to open all surrounding square
        (type INTEGER)
        (allowed-integers 0 1)
        (default 0)
    )
)

(defrule initialize ; Start program
    ?init <- (square (is-open 0) (x 0) (y 0))
=>
    (printout t "Game Start!" crlf)
    (modify ?init (is-open 1))
)

(defrule lose-Game 
; When program opened a bomb square
    (declare (salience 1000))
    (square (value -1) (is-open 1))
=>
    (printout t "Oops, wrong step! You lose!")
    (halt)
)


(defrule open-surrounding-square
; Open surrounding square of an empty square
    (declare (salience 100))
    (square (is-open 1) (x ?x1) (y ?y1) (value 0))
    ?open-square <- (square (is-open 0) (x ?x2) (y ?y2))
    (test (>= 1 (abs (- ?x2 ?x1))))
    (test (>= 1 (abs (- ?y2 ?y1))))
=>
    (modify ?open-square (is-open 1))
)

(defrule subtract-surrounding-square 
; When a box is opened, subtract surrounding square's closed-square-around
    (declare (salience 110))
    ?opened-square <- (square (is-open 1) (x ?x1) (y ?y1) (subtracted-coordinates-after-open $?mf))
    ?adj-square <- (square (x ?x2) (y ?y2) (closed-square-around ?c))
    (test (not (and (= ?x2 ?x1) (= ?y2 ?y1))))
    (test (not (member$ (str-cat ?x2 "," ?y2) ?mf)))
    (test (>= 1 (abs (- ?x2 ?x1))))
    (test (>= 1 (abs (- ?y2 ?y1))))
=>
    (modify ?adj-square (closed-square-around (- ?c 1)))
    (modify ?opened-square (subtracted-coordinates-after-open (insert$ ?mf 1 (str-cat ?x2 "," ?y2))))
)


(defrule value-equals-closed
; When square's value is equal to closed-square-around, flag surrounding square
    ?opened-square <- (square (is-open 1) (value ?value) (flag-all-around 0) (closed-square-around ?closed) (open-all-around 0))
    (test (!= ?value 0))
    (test (= ?value ?closed))
=>
    (modify ?opened-square (flag-all-around 1))
)

(defrule if-flag-all-around
; When a square's flag-all-around = 1
    (square (is-open 1) (x ?x1) (y ?y1) (flag-all-around 1) )
    ?adj-square <- (square (is-open 0) (is-flag 0) (x ?x2) (y ?y2))
    (test (>= 1 (abs (- ?x2 ?x1))))
    (test (>= 1 (abs (- ?y2 ?y1))))
    ?board <- (board (remaining-bomb ?b))
=>
    (modify ?board (remaining-bomb (- ?b 1)))
    (modify ?adj-square (is-flag 1))
    (printout t "bomb in (" ?x2 ", " ?y2 ") " crlf)
)

(defrule subtract-flagged-box
; Update square's info about a recently flagged box
    (declare (salience 110))
    ?init-square <- (square (is-flag 1) (x ?x1) (y ?y1) (subtracted-coordinates-after-open $?mf))
    ?adj-square <- (square (x ?x2) (y ?y2) (flagged-square-around ?c))
    (test (not (and (= ?x2 ?x1) (= ?y2 ?y1))))
    (test (not (member$ (str-cat ?x2 "," ?y2) ?mf)))
    (test (>= 1 (abs (- ?x2 ?x1))))
    (test (>= 1 (abs (- ?y2 ?y1))))
=>
    (modify ?adj-square (flagged-square-around (+ ?c 1)))
    (modify ?init-square (subtracted-coordinates-after-open (insert$ ?mf 1 (str-cat ?x2 "," ?y2))))
)

(defrule safe-surrounding
; Surrounding square's bomb have all been flagged, so open other squares
    ?opened-square <- (square (is-open 1) (value ?value) (flag-all-around 0) (open-all-around 0) (flagged-square-around ?flagged))
    (test (!= ?value 0))
    (test (= ?flagged ?value))
=>
    (modify ?opened-square (open-all-around 1))
)

(defrule if-open-all-around
; Open all surrounding not flagged and  closed square
    (square (is-open 1) (x ?x1) (y ?y1) (open-all-around 1) )
    ?adj-square <- (square (is-open 0) (is-flag 0) (x ?x2) (y ?y2))
    (test (>= 1 (abs (- ?x2 ?x1))))
    (test (>= 1 (abs (- ?y2 ?y1))))
=>
    (modify ?adj-square (is-open 1))
)


; K -> Kosong
; B -> Bo

; K | 2 | B
; K | 3 | B
; 1 | B | K

(deffacts initial-dummy ; Solved by 28 November 2020 14.00
    (board (size 3) (remaining-bomb 4))
    (square (x 0) (y 0) (value 0) (closed-square-around 3))
    (square (x 0) (y 1) (value 2) (closed-square-around 5))
    (square (x 0) (y 2) (value -1) (closed-square-around 3))
    (square (x 1) (y 0) (value 2) (closed-square-around 5))
    (square (x 1) (y 1) (value 4) (closed-square-around 8))
    (square (x 1) (y 2) (value -1) (closed-square-around 5))
    (square (x 2) (y 0) (value -1) (closed-square-around 3))
    (square (x 2) (y 1) (value -1) (closed-square-around 5))
    (square (x 2) (y 2) (value 2) (closed-square-around 3))
)

; K | 1 | B
; K | 2 | 2
; K | 1 | B

; (deffacts initial-dummy-2
;     (board (size 3) (remaining-bomb 3))
;     (square (x 0) (y 0) (value 0) (closed-square-around 3))

;     (square (x 0) (y 1) (value 1) (closed-square-around 5))

;     (square (x 0) (y 2) (value -1) (closed-square-around 3))

;     (square (x 1) (y 0) (value 0) (closed-square-around 5))

;     (square (x 1) (y 1) (value 2) (closed-square-around 8))

;     (square (x 1) (y 2) (value 2) (closed-square-around 5))

;     (square (x 2) (y 0) (value 0) (closed-square-around 3))

;     (square (x 2) (y 1) (value 1) (closed-square-around 5))

;     (square (x 2) (y 2) (value -1) (closed-square-around 3))
; )

; (deffacts initial-dummy-3
;     (board (size 2) (remaining-bomb 0))
;     (square (x 0) (y 0) (value 0) (closed-square-around 3))

;     (square (x 0) (y 1) (value 1) (closed-square-around 3))
    
;     (square (x 1) (y 0) (value 1) (closed-square-around 3))
    
;     (square (x 1) (y 1) (value 1) (closed-square-around 3))
; )