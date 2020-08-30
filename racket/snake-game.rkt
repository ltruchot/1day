#lang racket
(require r-cade)
(require racket/trace)

; grid definitions
;; grid values
(define grid-size 21)
(define max-grid-index (- grid-size 1))
(define grid
  (build-list
   grid-size
   (lambda (y)
     (build-list grid-size (lambda (x) (list x y "blank"))))))

;; grid functions
;;; read 1 tile
(define (read-tile coord)
  (let* ([row (list-ref grid (list-ref coord 1))]
        [tile (list-ref row (list-ref coord 0))]) 
         tile))
;;; update 1 tile
(define (update-tile coord val)
  (set! grid
        (list-update
         grid
         (list-ref coord 1)
         (lambda (row)
           (list-update
            row
            (list-ref coord 0)
            (lambda (tile)
              (list-set tile 2 val)))))))

;;; update several tiles
(define (update-tiles coords val)
  (for-each
   (lambda (coord)(update-tile coord val))
   coords))

; wall definitions
(define wall-coords
  (let ([top (build-list grid-size (lambda (x)(list x 0)))]
        [bottom (build-list grid-size (lambda (x)(list x max-grid-index)))]
        [left (build-list (- grid-size 2) (lambda (y)(list 0 (+ y 1))))]
        [right (build-list (- grid-size 2) (lambda (y)(list max-grid-index (+ y 1))))]

        )
    (append top bottom left right)))

; draw definitions
(define (color-code tile-type)
  (case tile-type
    [("wall") 4]
    [("snake") 11]
    [("apple") 8]
    [else 7]))

(define (draw-grid grid)
  (for-each
   (lambda (row)
     (for-each
      (lambda (tile)
        (begin (color (color-code (list-ref tile 2)))
               (rect
                (list-ref tile 0)
                (list-ref tile 1)
                1 1
                #:fill #t))) row)) grid))


; snake definitions
(define snake-coords
  (let ([val (round (- ( / grid-size 2) 1))])
    (list val val)))

(define (snake-position-update)
  (begin (update-tile snake-coords "empty")
         (let* ([new-coords (list (list-ref snake-coords 0) (- (list-ref snake-coords 1) 1))]
                [next-tile (read-tile new-coords)])
           (if (not (equal? (list-ref next-tile 2) "empty"))
               (begin
                 (set! snake-coords new-coords)
                 (update-tile new-coords "snake"))
               (begin (print "quit")(quit))))))

; game definitions
(define (game-loop)
  (cls)
  (snake-position-update)
  (draw-grid grid))

; procedure
(update-tiles wall-coords "wall")
(update-tile snake-coords "snake")
(run game-loop grid-size grid-size #:fps 2)
