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
;;; check if a tile is blank
(define (is-tile-blank coords)
  (let* ([tile (read-tile coords)]
         [type (list-ref tile 2)])
    (equal? type "blank")))
(define (is-tile-apple coords)
  (let* ([tile (read-tile coords)]
         [type (list-ref tile 2)])
    (equal? type "apple")))

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
    (list (list val val))))
(define snake-direction "up")
(define opposite-direction "down")



;;; setters
(define (move direction)
  (begin
    (when
        (not (equal? direction opposite-direction))
      (begin
        (set! snake-direction direction)
        (set! opposite-direction
              (case snake-direction
                [("up") "down"]
                [("right") "left"]
                [("down") "up"]
                [("left") "right"]))))))

;;; actions mapping
(define (snake-action)
  (let ([direction (cond [(btn-up) "up"]
                         [(btn-right) "right"]
                         [(btn-down) "down"]
                         [(btn-left) "left"]
                         [else snake-direction])])
    (move direction)))


; apples
(define (draw-random-apple)
  (let* ([x (random 1 20)]
         [y (random 1 20)]
         [coords (list x y)])
    (if (is-tile-blank coords)
        (update-tile coords "apple")
        (draw-random-apple))))


; game definitions
(define game-speed 5)

(define (game-update)    
  (let*
      ([x (list-ref (first snake-coords) 0)]
       [y (list-ref (first snake-coords) 1)]
       [new-coords(case snake-direction
          [("top")(list x (- y 1))]
          [("down")(list x (+ y 1))]
          [("right")(list (+ x 1) y)]
          [("left")(list (- x 1) y)])])
    (cond [(is-tile-blank new-coords)
           (begin
             (update-tile (last snake-coords) "blank")
             (set! snake-coords
                   (drop-right
                    (append (list new-coords) snake-coords) 1))
             (update-tiles snake-coords "snake"))]
          [(is-tile-apple new-coords)
           (begin
             (set! snake-coords
                   (append (list new-coords) snake-coords))
             (update-tiles snake-coords "snake")
             (draw-random-apple))]
          [else (quit)])))

(define (game-loop)
  (cls); clear screen
  (snake-action); get user inputs
  (when
      (=
       (modulo (frame) (/ 60 game-speed))
       0)
    (game-update)); refresh the view with new data
  (draw-grid grid))

; procedure
(update-tiles wall-coords "wall")
(update-tiles snake-coords "snake")
(draw-random-apple)
(run game-loop grid-size grid-size #:fps 60)


