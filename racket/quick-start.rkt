#lang slideshow
(define wheel
  (let([tire (disk 30)]
       [hubcap
        (colorize (disk 25) "white")])
    (cc-superimpose tire hubcap)))
(define wheels
  (hc-append 100 wheel wheel))
(define (car color)
  (let* ([1st-part
          (filled-rectangle 90 20)]
         [2nd-part
          (filled-rectangle 180 20)]
         [compartment
          (colorize 1st-part color)]
         [body (colorize
                2nd-part color)])
    (vc-append compartment body wheels)))

(define (house color)
  (let* ([size 30]
         ; diagonal to assemble well sized home and roof
         [diag (* (sqrt 2) size)]
         ; base rectangles for roof, home, door
         [rect1 (filled-rectangle 30 30)]
         [rect2 (filled-rectangle diag diag)]
         [rect3 (filled-rectangle 10 20)]
         ; roof is a rotated/clipped square
         ; (in other word, a triangle)
         [roof (let* ([colored (colorize rect1 color)]
                      [rotated (rotate colored (/ pi 4))])
                 (inset rotated 0 0 0 -20))]       
         [home (colorize rect2 color)]
         ; structure is just a roof on a home
         [structure  (vc-append roof home)]
         [door (colorize rect3 "gray")])
    ;let's add a door on bottom
    (cb-superimpose structure door)))


(define blue "blue")
(define red "red")
; draw function
(define (draw n
              size
              color
              thing
              [pict (blank)])
  (if (> n 0)
      (let ([scale-size 
             (case size [("small") 0.5]
               [("big") 2]
               [else 1]
               )])
        (draw (- n 1)
              size
              color
              thing
              (hc-append pict
                         (scale
                          (thing color)
                          scale-size))))
      pict))
