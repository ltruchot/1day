#lang racket
(require r-cade)

; grid definitions
; -- size of a side
(define grid-size 21)

; -- biggest index
(define max-grid-index (- grid-size 1))

; -- mutable grid with only blank tiles at first
(define grid
  (build-list
   grid-size
   (lambda (y)(build-list
               grid-size
               (lambda (x) (list x y "blank"))))))

; -- read 1 tile in grid
(define (read-tile coord)
  (let* ([row (list-ref grid (list-ref coord 1))]
         [tile (list-ref row (list-ref coord 0))]) 
    tile))

; -- check tile type in grid
(define (is-tile-of-type coords type)
  (let* ([tile (read-tile coords)]
         [tile-type (list-ref tile 2)])
    (equal? type tile-type)))

; -- check if tile is blank
(define (is-tile-blank coords)
  (is-tile-of-type coords "blank"))

; -- check if tile is apple
(define (is-tile-apple coords)
  (is-tile-of-type coords "apple"))

; -- update 1 tile in grid
(define (update-tile coord val)
  (let* ([row-idx (list-ref coord 1)]
         [cell-idx (list-ref coord 0)]
         [row (list-ref grid row-idx )]
         [tile (list-ref row cell-idx)]
         [updated (list-set tile 2 val)])
    (set!
     grid (list-set grid row-idx
                    (list-set row cell-idx updated)))))

; -- update a list of tiles
(define (update-tiles coords val)
  (for-each
   (lambda (coord)(update-tile coord val))
   coords))

; wall definitions
; -- list of wall coordinates
(define wall-coords
  (let ([top (build-list grid-size (lambda (x)(list x 0)))]
        [bottom (build-list grid-size (lambda (x)(list x max-grid-index)))]
        [left (build-list (- grid-size 2) (lambda (y)(list 0 (+ y 1))))]
        [right (build-list (- grid-size 2) (lambda (y)(list max-grid-index (+ y 1))))]

        )
    (append top bottom left right)))

; draw definitions
; -- color code association to tile type
(define (color-code tile-type)
  (case tile-type
    [("wall") 4]
    [("snake") 11]
    [("apple") 8]
    [else 7]))

; -- draw colored grid on screen with
(define (draw-grid grid)
  (for-each
   (lambda (row)
     (for-each
      (lambda (tile)
        (let ([type (list-ref tile 2)]
              [x (list-ref tile 0)]
              [y (list-ref tile 1)])
          (begin
            (color (color-code type)); color setted for next function
            (rect x y 1 1 #:fill #t))))
      row))
   grid))


; snake definitions
; -- mutable list of coordidnate
(define snake-coords
  (let ([val (round (- ( / grid-size 2) 1))])
    (list (list val val))))

; -- mutable snake current direction
(define snake-direction "up")

; -- mutable direction opposed to current
(define opposite-direction "down")

; -- re-calculate opposite direction
(define (set-opposite-direction dir)
  (set! opposite-direction
        (case dir
          [("up") "down"]
          [("right") "left"]
          [("down") "up"]
          [("left") "right"])))

; -- change direction
(define (move direction)
  (when
      (not (equal? direction opposite-direction))
    (set! snake-direction direction)))

; -- user actions on snake
(define (snake-action)
  (let ([direction
         (cond [(btn-up) "up"]
               [(btn-right) "right"]
               [(btn-down) "down"]
               [(btn-left) "left"]
               [else snake-direction])])
    (move direction)))

; apples definitions
; -- draw an new random apple
(define (draw-random-apple)
  (let* ([x (random 1 20)]
         [y (random 1 20)]
         [coords (list x y)])
    (if (is-tile-blank coords)
        (update-tile coords "apple")
        (draw-random-apple))))


; game definitions
; -- game speed by frame (a multiple of 60)
(define game-speed 6)

; -- changes calculated on game update
(define (game-update)    
  (let*
      ([x (list-ref (first snake-coords) 0)]
       [y (list-ref (first snake-coords) 1)]
       [new-coords
        (case snake-direction
          [("up")(list x (- y 1))]
          [("down")(list x (+ y 1))]
          [("right")(list (+ x 1) y)]
          [("left")(list (- x 1) y)])]
       [new-snake (append (list new-coords) snake-coords)])
    (cond [(is-tile-blank new-coords)
           (begin
             (update-tile (last snake-coords) "blank")
             (set! snake-coords (drop-right new-snake 1))
             (update-tiles snake-coords "snake")
             (set-opposite-direction snake-direction))]
          [(is-tile-apple new-coords)
           (begin
             (set! snake-coords new-snake)
             (update-tiles snake-coords "snake")
             (set-opposite-direction snake-direction)
             (draw-random-apple))]
          [else (quit)])))

; -- loop that will run until game over
(define (game-loop)
  (cls); clear screen
  (snake-action); get user inputs
  (when
      (=
       (modulo (frame) (/ 60 game-speed))
       0)
    (game-update)); refresh the view with new data
  (draw-grid grid))

; final procedure
(update-tiles wall-coords "wall")
(update-tiles snake-coords "snake")
(draw-random-apple)
(run game-loop grid-size grid-size #:fps 60); launch game!


