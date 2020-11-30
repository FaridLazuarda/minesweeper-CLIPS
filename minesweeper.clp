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

    (slot bomb-subtracted-from-board
        (type INTEGER)
        (allowed-integers 0 1)
        (default 0)
    )
)  

; (deffacts initial-dummy-check-1-2-1 ; Buat Ngecek pattern 1-2-1
;     (square (y 0) (x 0) (value 1) (closed-square-around 3) (is-open 1))
;     (square (y 0) (x 1) (value 2) (closed-square-around 5) (is-open 1))
;     (square (y 0) (x 2) (value 1) (closed-square-around 3) (is-open 1))
;     (square (y 1) (x 0) (value -1) (closed-square-around 3) (is-open 0))
;     (square (y 1) (x 1) (value -1) (closed-square-around 5) (is-open 0))
;     (square (y 1) (x 2) (value -1) (closed-square-around 3) (is-open 0))
; )

(deffunction is-one-line-3 (?x1 ?x2 ?x3 ?y1 ?y2 ?y3)
    (if (and (= ?x1 ?x2) (= ?y2 (+ ?y1 1)))
        then
        (if (and (= ?x2 ?x3) (= ?y3 (+ ?y2 1)))
            then (return 1)
        )
    )

    (return 0)
)

(deffunction is-one-line-4 (?x1 ?x2 ?x3 ?x4 ?y1 ?y2 ?y3 ?y4)
    (if (and (= ?x1 ?x2) (= ?y2 (+ ?y1 1)))
        then
        (if (and (= ?x2 ?x3) (= ?y3 (+ ?y2 1)))
            then 
            (if (and (= ?x3 ?x4) (= ?y4 (+ ?y3 1)))
                then (return 1)
            )
        )
    )

    (return 0)
)

(deffunction different-square(?x1 ?y1 ?x2 ?y2)
    (if (or (!= ?x1 ?x2) (!= ?y1 ?y2))
        then (return 1)
    )
    (return 0)
)

(deffunction is-1-2-1 (?x1 ?x2 ?x3 ?x4 ?x5 ?x6 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6)
    (if (= 1 (is-one-line-3 ?x1 ?x2 ?x3 ?y1 ?y2 ?y3))
        then
        (if (and (= ?x1 (+ ?x4 1)) (= ?y1 ?y4))
            then
            (if (and (= ?x2 (+ ?x5 1)) (= ?y2 ?y5))
                then
                (if (and (= ?x3 (+ ?x6 1)) (= ?y3 ?y6))
                    then
                    (return 1)
                )
            )
        )
    )

    (if (= 1 (is-one-line-3 ?x1 ?x2 ?x3 ?y1 ?y2 ?y3))
        then
        (if (and (= ?x1 (- ?x4 1)) (= ?y1 ?y4))
            then
            (if (and (= ?x2 (- ?x5 1)) (= ?y2 ?y5))
                then
                (if (and (= ?x3 (- ?x6 1)) (= ?y3 ?y6))
                    then
                    (return 1)
                )
            )
        )
    )

    (return 0)
)

(deffunction is-1-2-2-1 (?x1 ?x2 ?x3 ?x4 ?x5 ?x6 ?x7 ?x8 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6 ?y7 ?y8)
    (if (= 1 (is-one-line-4 ?x1 ?x2 ?x3 ?x4 ?y1 ?y2 ?y3 ?y4))
        then
        (if (and (= ?x1 (+ ?x5 1)) (= ?y1 ?y5))
            then
            (if (and (= ?x2 (+ ?x6 1)) (= ?y2 ?y6))
                then
                (if (and (= ?x3 (+ ?x7 1)) (= ?y3 ?y7))
                    then
                    (if (and (= ?x4 (+ ?x8 1)) (= ?y4 ?y8))
                        then
                        (return 1)
                    )
                )
            )
        )
    )

    (if (= 1 (is-one-line-4 ?x1 ?x2 ?x3 ?x4 ?y1 ?y2 ?y3 ?y4))
        then
        (if (and (= ?x1 (- ?x5 1)) (= ?y1 ?y5))
            then
            (if (and (= ?x2 (- ?x6 1)) (= ?y2 ?y6))
                then
                (if (and (= ?x3 (- ?x7 1)) (= ?y3 ?y7))
                    then
                    (if (and (= ?x4 (- ?x8 1)) (= ?y4 ?y8))
                        then
                        (return 1)
                    )
                )
            )
        )
    )

    (return 0)
)

(defrule 1-2-1-pattern
    ?square1 <- (square (is-open 1) (x ?x1) (y ?y1) (value ?v1) (flagged-square-around ?f1))
    ?square2 <- (square (is-open 1) (x ?x2) (y ?y2) (value ?v2) (flagged-square-around ?f2))
    ?square3 <- (square (is-open 1) (x ?x3) (y ?y3) (value ?v3) (flagged-square-around ?f3))
    ; Apakah mereka semua beda square
    (test (= 1 (different-square ?x1 ?y1 ?x2 ?y2)))
    (test (= 1 (different-square ?x1 ?y1 ?x3 ?y3)))
    (test (= 1 (different-square ?x2 ?y2 ?x3 ?y3)))

    ; Apakah jumlah bom yang tersisa samadengan 121
    (test (= 1 (- ?v1 ?f1)))
    (test (= 2 (- ?v2 ?f2)))
    (test (= 1 (- ?v3 ?f3)))

    ; Square yang mau dicek di depannya
    ?square4 <- (square (is-open 0) (x ?x4) (y ?y4) (is-flag 0))
    ?square5 <- (square (is-open 0) (x ?x5) (y ?y5) (is-flag 0))
    ?square6 <- (square (is-open 0) (x ?x6) (y ?y6) (is-flag 0))
    
    ; Apakah memenuhi fungsi 1-2-1 nya
    (test 
        (or 
            ; 1-2-1 horizontal
            (= 1 (is-1-2-1 ?x1 ?x2 ?x3 ?x4 ?x5 ?x6 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6)) 
            ; 1-2-1 vertikal
            (= 1 (is-1-2-1 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6 ?x1 ?x2 ?x3 ?x4 ?x5 ?x6))))
    

=>
    (modify ?square4 (is-flag 1))
    (modify ?square5 (is-open 1))
    (modify ?square6 (is-flag 1))
    (printout t "Used 1-2-1 rule" crlf)
)

(defrule 1-2-2-1-pattern
    ?square1 <- (square (is-open 1) (x ?x1) (y ?y1) (value ?v1) (flagged-square-around ?f1))
    ?square2 <- (square (is-open 1) (x ?x2) (y ?y2) (value ?v2) (flagged-square-around ?f2))
    ?square3 <- (square (is-open 1) (x ?x3) (y ?y3) (value ?v3) (flagged-square-around ?f3))
    ?square4 <- (square (is-open 1) (x ?x4) (y ?y4) (value ?v4) (flagged-square-around ?f4))
    
    ; Apakah mereka semua beda square
    (test (= 1 (different-square ?x1 ?y1 ?x2 ?y2)))
    (test (= 1 (different-square ?x1 ?y1 ?x3 ?y3)))
    (test (= 1 (different-square ?x1 ?y1 ?x4 ?y4)))
    (test (= 1 (different-square ?x2 ?y2 ?x3 ?y3)))
    (test (= 1 (different-square ?x2 ?y2 ?x4 ?y4)))
    (test (= 1 (different-square ?x3 ?y3 ?x4 ?y4)))

    ; Apakah jumlah bom yang tersisa samadengan 121
    (test (= 1 (- ?v1 ?f1)))
    (test (= 2 (- ?v2 ?f2)))
    (test (= 2 (- ?v3 ?f3)))
    (test (= 1 (- ?v4 ?f4)))

    ; Square yang mau dicek di depannya
    ?square5 <- (square (is-open 0) (x ?x5) (y ?y5) (is-flag 0))
    ?square6 <- (square (is-open 0) (x ?x6) (y ?y6) (is-flag 0))
    ?square7 <- (square (is-open 0) (x ?x7) (y ?y7) (is-flag 0))
    ?square8 <- (square (is-open 0) (x ?x8) (y ?y8) (is-flag 0))
    
    ; Apakah memenuhi fungsi 1-2-2-1 nya
    (test 
        (or 
            ; 1-2-2-1 horizontal
            (= 1 (is-1-2-2-1 ?x1 ?x2 ?x3 ?x4 ?x5 ?x6 ?x7 ?x8 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6 ?y7 ?y8)) 
            ; 1-2-2-1 vertikal
            (= 1 (is-1-2-2-1 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6 ?y7 ?y8 ?x1 ?x2 ?x3 ?x4 ?x5 ?x6 ?x7 ?x8))))
    

=>
    (modify ?square5 (is-open 1))
    (modify ?square6 (is-flag 1))
    (modify ?square7 (is-flag 1))
    (modify ?square8 (is-open 1))
    (printout t "Used 1-2-2-1 rule" crlf)
)


; K | K | K
; 1 | 1 | K
; K | -1 | K

(defrule 1-1-pattern
    ; 
    ?square1 <- (square (is-open 1) (x ?x1) (y ?y1) (value ?v1) (flagged-square-around ?f1) (closed-square-around ?c1))
    ?square2 <- (square (is-open 1) (x ?x2) (y ?y2) (value ?v2) (flagged-square-around ?f2) (closed-square-around ?c2))
    ?square3 <- (square (is-open 1) (x ?x3) (y ?y3) (value ?v3) (flagged-square-around ?f3) (closed-square-around ?c3))
    
    ; Apakah mereka semua beda square
    (test (= 1 (different-square ?x1 ?y1 ?x2 ?y2)))
    (test (= 1 (different-square ?x1 ?y1 ?x3 ?y3)))
    (test (= 1 (different-square ?x2 ?y2 ?x3 ?y3)))

    ; Apakah jumlah bom yang tersisa samadengan 11
    (test (= 1 (- ?v1 ?f1)))
    (test (= 1 (- ?v2 ?f2)))

    ; Square yang mau dicek di depannya
    ?square4 <- (square (is-open 0) (x ?x4) (y ?y4) (is-flag 0))
    ?square5 <- (square (is-open 0) (x ?x5) (y ?y5) (is-flag 0))
    ?square6 <- (square (is-open 0) (x ?x6) (y ?y6) (is-flag 0))

    ; jumlah kotak yang ketutup dan belom diflag harus 2 (close-square-around - flag-square-around)
    (test (= 2 (- ?c1 ?f1)))
    (test (= 3 (- ?c2 ?f2)))

    ; ; Apakah memenuhi fungsi 1-2-1 nya
    (test 
        (or 
            ; 1-2-1 horizontal
            (= 1 (is-1-2-1 ?x1 ?x2 ?x3 ?x4 ?x5 ?x6 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6)) 
            ; 1-2-1 vertikal
            (= 1 (is-1-2-1 ?y1 ?y2 ?y3 ?y4 ?y5 ?y6 ?x1 ?x2 ?x3 ?x4 ?x5 ?x6))))

=>
    (modify ?square6 (is-open 1))
    (printout t "Used 1-1 rule" crlf)
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

(defrule if-flagged
    ?flagged-square <- (square (is-flag 1) (bomb-subtracted-from-board 0))
    ?board <- (board (remaining-bomb ?b))
=>
    (modify ?flagged-square (bomb-subtracted-from-board 1))
    (modify ?board (remaining-bomb (- ?b 1)))
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
    ; ?board <- (board (remaining-bomb ?b))
=>
    ; (modify ?board (remaining-bomb (- ?b 1)))
    (modify ?adj-square (is-flag 1))
    ; (printout t "bomb in (" ?x2 ", " ?y2 ") " crlf)
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

; (defrule 1-2-1-patten

; )



; K -> Kosong
; B -> Bo

; K | 1 | 1
; K | 1 | -1
; K | 1 | 1

; (deffacts initial-dummy-0 
;     (board (size 3) (remaining-bomb 1))
;     (square (x 0) (y 0) (value 0) (closed-square-around 3))
;     (square (x 1) (y 0) (value 0) (closed-square-around 5))
;     (square (x 2) (y 0) (value 0) (closed-square-around 3))
;     (square (x 0) (y 1) (value 1) (closed-square-around 5))
;     (square (x 1) (y 1) (value 1) (closed-square-around 8))
;     (square (x 2) (y 1) (value 1) (closed-square-around 5))
;     (square (x 0) (y 2) (value 1) (closed-square-around 3))
;     (square (x 1) (y 2) (value -1) (closed-square-around 5))
;     (square (x 2) (y 2) (value 1) (closed-square-around 3))
; )

; K | 2 | B
; K | 3 | B
; 1 | B | K

; (deffacts initial-dummy ; Solved by 28 November 2020 14.00
;     (board (size 3) (remaining-bomb 4))
;     (square (x 0) (y 0) (value 0) (closed-square-around 3))
;     (square (x 0) (y 1) (value 2) (closed-square-around 5))
;     (square (x 0) (y 2) (value -1) (closed-square-around 3))
;     (square (x 1) (y 0) (value 2) (closed-square-around 5))
;     (square (x 1) (y 1) (value 4) (closed-square-around 8))
;     (square (x 1) (y 2) (value -1) (closed-square-around 5))
;     (square (x 2) (y 0) (value -1) (closed-square-around 3))
;     (square (x 2) (y 1) (value -1) (closed-square-around 5))
;     (square (x 2) (y 2) (value 2) (closed-square-around 3))
; )

; K | 1 | B
; K | 2 | 2
; K | 1 | B

; (deffacts initial-dummy-2
;     (board (size 3) (remaining-bomb 2))
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