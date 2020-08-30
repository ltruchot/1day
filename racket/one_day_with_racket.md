# One Day With Racket

## not enough parenthesis!

> 7:56 AM. What brought me there? I'm a JavaScript Senior, and it's often mentioned that
> JS what inspired by Scheme. Scheme appears to be a LISP,
> an old family of language very promising for A.I.,
> where everything is a function.
> It let you easily define a Domain Specific Language, with you own words.
> Scheme is a classic academic LISP from MIT, and Racket a scholar attempt
> to make LISP even more universally learnable (Logo is another well known).
> Let's make som Racket !

## Find Basic Documentation

Among the thousands of languages available, we can often find the main web site
of a particular one just typing \*\*\*-lang.org: rust-lang.org, elm-lang.org, etc.

Arriving to https://racket-lang.org, I'm happy to discover a clean and modern
website with living contents.

Before diving in the deep docs, I hope to find a clear introduction.
After few clicks I ended in the
[Quick Introduction to Racket with Pictures](https://docs.racket-lang.org/quick/index.html).

## Quick Introduction

It invite me to install
[Racket/DrRacket installer](https://download.racket-lang.org/) (~175Mb)
to be able to run the examples, so I do (choose CS Variant, the new recommended one).
A very simple and smooth process on Windows 10: let's open DrRacket now.

It's a very simple interface with a menu,
an empty document (named "definitions area")
and a REPL ("interactions area") with some guidance.

Introduction continue, and the documentation missed a little step:
before copy/past the provided samples, I had to choose the "racket lang"
in the languages menu. Then I paste `#lang slideshow` in the def area, and run.

!["Getting ready](./img/01-getting_rdy.png)

Our first lines of code will take place in the REPL.
Write `(circle 10)` and press enter draw a 10px circle in the same area.
You can imagine what the following stuff will do:

```scheme
(circle 10)
(circle 50)
(rectangle 100 20)
(arrow 20 10)
```

It draws shapes (and makes coffee)!
So we can guess that

- `#lang slideshow` contains stuff helpful to display some shapes
- `circle`, `rectangle`, `arrow` are function names
- we can execute thoses function by putting them between parenthesis, passing arguments separated by spaces inside the parens.
- the REPL is sufficient to interpret directly those inputs, and ouputs the result

!["REPL](./img/02-repl.png)

Just playing arround without checking the docs,
I finally makes some voluntary error to see how the interpreter is helpful

```scheme
(triangle 30)
(rectangle 10)
rectangle 10
```

- Errors about undefined stuff seems easy to grab
- Errors about arguments are little more scary: the technical word "arity" refers to the expected number of arguments of a function.
- Missing parens didn't show me an error, simply an unexpected result that I don't understand for now

Diving deeper, we discover that we can append several shapes on a line...

```scheme
(hc-append
    (rectangle 20 20)
    (circle 20)
)
```

I guess that `hc-append` stands for "horizontally centered append", but something blink in red here: naming function will be hard, since they are so important here...
!["REPL](./img/03-line_of_shapes.png)
... and it begins !

The infamous-lisp-parenthesis-festival that show the order of function execution.
In fact, my sensation is that it's clean and natural for now. The language itself seems to contains very few symbols for simple instructions.

## Create my own stuff

We only had use some already baked functions. How to make our owns ?

The next part of the quick-start show us how to do with the `define` identifier:

```scheme
(define c10 (circle 10))
c10
(hc-append c10 c10 c10 c10)
```

![define](./img/04-define.png)

`define` acts as a function that takes 2 args: a variable name, and a value. Now, c10 is available as a variable.

> 9:18 AM Because it feel astonishely simple to manipulate graphics, so I decide to write a snake-game in Racket before the sun goes down.

We can now define a lot of stuff:

```scheme
(define eye (circle 10))
(define nose (rectangle 10 20))
(ht-append eye nose eye)
(define face (ht-append eye nose eye))
face
face
```

But we reach the point where we loose some visiblity.
So let's use the "def area" for define instructions, and keep the REPL for the used expressions...

![my stuff](./img/05-my_stuff.png)

It's clearer now. And I have a program to save on disk: `quick-start.rkt`.
This is not the usual approach of programming of course, I'm used to a soup where everything is mixed.
Here, definitions stays "pure", and the process of creating the program is REPL-oriented, testing stuff until it work.

Few remarks:

- `ht-append` can take any number of args.If it begins by a number, this one will represent the white-space between picts; it reminds me the [overloading practice](https://www.w3schools.com/java/java_methods_overloading.asp) in OOP.
- `vc-append` work for vertical-centered, and so on with `ht`, `hb`, `vt`...
- when the mouse is over a defined name, DrRacket show an arrow to find the definition - I discover that by accident, and it's amazing
- there is no fatality about parenthesis hell, if we define names smartly along the way
- we already feel the potential of a DSL
  maker that is Racket. I can imagine a function to make a triangle, an other to do a square, an other to combine them and make a little house, and a house function just to wrap all of this... I reminds me the [SHRDLU](https://en.wikipedia.org/wiki/SHRDLU) initiative in A.I.

What about define my own function ? I.e. there is no `square` function in this package, so let's create one

Nothing too new:

```scheme
(define (square n)
  (rectangle n n))
```

In place of taking a var name, define takes a function name + some args, surrounded by parens.
Then, a second pair of parens contains the actual code to run.
And here is my little 30px square:

![my stuff](./img/06-square.png)

## My first challenge

> 10:10 AM - I just decided to challenge my-self. Can I create a function able to draw colored cars ?

I don't want to only stick to the tutorial. If I find the documentation for `circle` and `hc-append`, I'm pretty sure I will know all the shapes available, and all the ways to combine them.
Here we are, no surprise:

![docs](./img/07-docs.png)

What I need is a kind of `disk` for the wheel, and it exists. Now, how to put a white disk in a slightly bigger black disk ?
It appears there is a `colorize` function that take any "pict" (our shapes) and an [x11 color](https://docs.racket-lang.org/draw/color-database___.html) as 2d arg.

```scheme
(disk 30) ; a disk, black by default
(colorize (disk 25) "lightgray") ; a gray disk
```

We can even put them together with the `cc-superimpose` function, a way to super impose on center - center!

```scheme
(define black-disk
    (disk 30))
(define gray-disk
    (colorize
        (disk 25)
        "white"))
(cc-superimpose black-disk gray-disk)
```

So my final definitions could be

```scheme
(define tire
    (disk 30))
(define hubcap
    (colorize (disk 25) "white"))
(define wheel
    (cc-superimpose tire hubcap))
(define wheels
    (hc-append 100 wheel wheel))
(define (car color)
    (define body
        (colorize
            (filled-rectangle 180 20)
            color))
    (vc-append body wheels))
```

and let's try

![cars](./img/08-cars.png)

OMG, so easy. What is this strange feeling ? Am I a wizard or something ? It work so well, and it was just some instinct + few RTFM work: thank you DrRacket!

As you can see, I tried to define a function in a function for the body of my car. I was not sure it will work, but it did!

Going further in the documentation, it appears that's the job of the `let`/`let*` identifier too (the `*` authorize several `let` to use each others)

```scheme
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
```

This little recfacto limit the scope of my definition: that's always a good practice, and I can of course going further, while putting everything in the car definition.

![use let*](./img/09-violet_car.png)

## First citizen

One of the big strenght of JavaScript is the "function as value", in other word the fact that a function can take another one as argument (aka higher-order functions).

```javascript
function example(callback) {
  console.log("hello");
  callback();
}
example(() => console.log("world!"));
```

And of course you can put functions in variables, or even make a function that return an other one (aka curriying, thank God for the arrow functions).

```javascript
const car = (size) => (color) => {
  console.log(`It's a ${size} ${color} car!`);
};
const bigCar = car("big");
const smallCar = car("small");
bigCar("blue");
bigCar("red");
smallCar("violet");
```

This is the heritage of LISP, so in Racket we can also pass function to another as argument, and so on. Functions are values likes the others (aka first-class citizen functions)

Ok, in wich case this will happen ?

> 10:51 AM - I have an idea. I want to be able to ask the program a specific number of colored cars or houses. I suspect it will request use of "functions as value".

Let's make a house. I had to dive in the documentation to find `rotate`, `inset`, `pi`, `sqrt`, without any surprise.
Before you read this code, be prepared:
In LISP, math operators are functions, defined and working like any other. So:

```scheme
(+ 1 2) ; returns 3
(* 4 3) ; returns 12
(/ 8 2) ; returns 4
(= 5 5) ; returns true (#t) since it checks number equality
; and so on.
```

In other word, no more "infix" operators (symbol in between the 2 operands): an addition is no more than a simple function and it signature is `(number, number) -> number`.

```scheme
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
```

This is improvisation, but it work! Even if this piece of code appears complexe, I can sware it was easy to write ! And now, let's just use `(house "color")` everywhere...

![blue house](./img/10-blue_house.png)

Know let's image this very special function. I just want to say "draw 3 blue houses" and get my stuff, some signature like `(n color thing) -> pict`

```scheme
; dumb color identifiers
(define blue "blue")
(define red "red")
; draw function
(define (draw n color thing)
    (hc-append (thing color)))
(draw 1 blue house)
(draw 1 red car)
```

It work and we can see here that `thing` are "functions as values", where draw is an "higher order function", a function in charge the execute other functions.

The next challenge is to do something with this `n` parameter. I need a "for loop", but guess what, it's not idiomatic Racket! Indeed, Racket is not a big set of reserved imperative keyword like other languages are. In contrary, it's a very few set of powerful identifiers (`define`, `let`...) sufficient to create our own language (And indeed, some forms of "for" or "while" exists in Racket langs/libraries/modules) as defined functions.

Basic iteration will be build on top of recursion. In JavaScript, a recursion looks like:

```javascript
const recursiveFunction = (n) => {
  if (n <= 0) {
    console.log("the end!");
  } else {
    console.log("n is now " + n);
    recursiveFunction(n - 1);
  }
};
recursiveFunction(10);
```

The loop occurs because the function call itself until a condition is reached - or "while" a condition still valid (just like any loop in fact - but recursion shows that functions can be loops, and "for" or "while" is an optional tool).

Let's try this recursion in Racket. Before that will need few new tools that I easily found in the documentation:

- `print` that write in the console like `console.log`
- `string-append` for string concatenation
- `number->string` to cast a number in string

```scheme
(define (recursive-function n)
  (print (string-append
          "n is now "
          (number->string n))))
```

Last but not least:

- `if` is a function like all the others, it takes 3 args: a "test", a "then" and a "else"

```
(print (if
        (= 3 3)
        "3 is 3"
        "wtf" ))
```

- `begin` is a function to excute several functions one by one, and just keep the result of the last
  Ok, let's put all the piece together

```scheme
(define (recursive-function n)
  (let ([msg1 "the end!"]
        [msg2 (string-append
               "n is now "
               (number->string n))])
    (if
     (<= n 0)
     (print msg1)
     (begin (print msg2)
            (recursive-function (- n 1))))))
(recursive-function 10)
```

![recursion](./img/11-recursion.png)

If we want to append recursively pictures to a previous pictures,
we have to begin with some kind of "empty" picture.
Indeed, a function that add "1" to nothing will break: 
it must add 1 at least to a 0. This empty case is named [blank](https://docs.racket-lang.org/pict/Basic_Pict_Constructors.html?q=pict#%28def._%28%28lib._pict%2Fmain..rkt%29._blank%29%29)
in the library.

And now, we can apply recursion to our example:

```scheme
; draw function
(define (draw n color thing [pict (blank)])
  (if (> n 0);if n > 0
      (draw (- n 1); continue to draw
            color
            thing
            (hc-append pict (thing color)))
      pict)); else return the pict
```

![draw me](./img/12-draw_me.png)

Hey, what is this unknown [pict (blank)] ? It's a way to provide an optional
parameters with a default value.
In ES6, it could be mirrored with:

```javascript
function draw(n, color, thing, pict = new Pict()) {}
```

assuming there is a Pict constructor that return an empty pict.

In fact, our case is a beautiful illustration
of what mathematician calls a `Monoid`.
We have a special algebra for `pict`
where we can add them infinitely, producing a new `pict`, beginnig with operation
with the `blank` neutral element. This case is so common in Computer Science
(addition with 0 as neutral, multiplication with 1 as neutral, etc.)
that the type/class `Monoid` itself exists in different languages and frameworks.

## First Conclusions

> 2:16 PM - Sorry but I'm starving. it's time for a lunch,
>
> 3:15 PM - Wow. We have made a lot this morning, but time flies. Let' take stock, then move on to the next id: a animated game.

Racket (and so LISP) appears to be incredibely simple to write. Final instructions like `draw me a sheep` are easy to read too, very close to natural language if definitions are done that way.

Nonetheless it still difficult for me to read implementation details, especially when definition goes crazy. So I recommend to do little steps and focus on quality and modularization of ideas from the beginning.

The first big secret that Racket teach me is the following: you can do more with less. It sounds like Taoism, but indeed clarity grows because the field is almost empty. Very few building blocks, but they contains an unlimited power, by the law of combinations (like so much other fields).

If you dive in a definition, you will see other definitions that look the same, so declarativness is always preserved (and I advocate for that in all language, so I'm filled).

Imperativeness can be always avoided. And because everything is finally a simple list of stuff that begin with an identifier, you can understand the all language mechanics in few minutes. Which identifier exists or not is not the real question: you take take the fewest or a enormous backed-in DSL to start, as you wish.

- (define x y)
- (define (x y) z)
- (+ 1 2)
- (if x y z)
- (list "blue" "red" "green")
- (map (lambda (x) (\* x x)) a-list)
- and so on

We know that LISP stands for **LIS**t **P**rocessor and know we understand why. We see clearly why it's a good language for learning basics of CS, and even why Uncle Bob itself says that maybe in the future a lot a disparate language will converge on some kind of LISP.

If one day hardware capacity is no more a limitation, it can be indeed the only language to produce any DSL you want, that all developer could understand around the world without struggling with new weird language mechanics, but focus on a syntax+algebra that describe perfectly a domain...

## Go Back To Work

Now 2 new crazy challenges:

- What about asking for "4 big blue houses"?
- How to make stuff moving in time?

### Scaling

Diving the docs, I discovered that that Racket is strongly typed.
WTF? I didn't write any type since the beginning!

Indeed, it's dynamically typed,
but it's not loosely typed: those are 2 different concepts.
In JavaScript "number" is a lose type for all kinds of numbers.
In racket, a number have a stonger type, like "integer",
but it still being automatically assigned (like in JS).

One very smart thing about the `pict-lib` provided by `#lang/slideshow`,
is that almost all function takes `pict` typed value and return a `pict` as well.
That's why we can combine them, and reuse them.

So

```
(scale (house "orangered") 2)
(scale (rotate
        (car "powderblue")
        (/ pi 5))
       0.5)
```

should work perfectly.

![scale 1](./img/13-scale1.png)

Now let's enhance our legacy code. If we want to be able to ask for a big, small or normal-sized house we will need some kind of `switch` or `else if` statement. I discovered in the docs that switch is feasable using [case](https://docs.racket-lang.org/guide/case.html) where else-if is more like [cond](https://docs.racket-lang.org/reference/if.html)

```scheme
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
```

![scale 2](./img/14-scale2.png)

### Moving

The future snake will be moving in the plane.
Is it even possible with our current `lang/slideshow` ? There is indeed an [animation documentation](https://docs.racket-lang.org/pict/Animation_Helpers.html), but it appears to be highly related to slideshow stuff.
And after moving, we will need a window, a game loop, collision stuff and so own.
Let's take some time to choose a better `lang` than slideshow for this advanced visual stuff ?

> It's already 4:45 PM. Do we have a chance to run something before midnight ? Differents tools appears to make games, dependant on new stuff.
> Like this [racket/gui](https://docs.racket-lang.org/gui/index.html) that will force us to learn a new way to draw: the `draw-lib`...
> [Searching](https://pkgd.racket-lang.org/pkgn/search?q=game) takes time but I thing I've now all the resource I need.
> I even found a [fully working snake game](https://github.com/Bogdanp/hebi/blob/master/hebi.rkt), but the code is too avanced for me...
> 5:09. At the end, my choice falls for the [r-cade packages](https://docs.racket-lang.org/r-cade/index.html) - it seems to contains everything we need, and claim to have snake-game example (that I will avoid now, but comparate at the end as correct version)

## A Snake Game

### R-cade Setup

Let's try the simplest example game

```scheme
#lang racket
(require r-cade)

; main function, called once per frame
(define (game-loop)
  (cls) ; clear view each frame
  (text 2 2 (frame))) ; show frame number as text

; 128px window runing a loop at 60frame/s speed
(run game-loop 128 128)
```

Oh no! `r-cade` is not know by DrRacket. Hopefully the error provide me an install link... that work directly.

Oh no! `r-cade` needs some dependencies on windows to run!
It's well documented [here](https://r-cade.io/setup). I install [csfml](https://www.sfml-dev.org/download/csfml/) (I unzip in a freshly made `C:\other_program\csfml` folder to be sure to not pollute my computer), and add the path to the windows Path environment variable.

![env csfml](./img/15-env_csfml.png)

I had to install [OpenAL](https://www.openal.org/downloads/) as well, then fully restart DrRacket to be able to run my sample.

![r-cade](./img/16-r-cade.png)

### Snake Specification

What is a Snake Game? Here is wy very personal breaking parts for a simplified snake game

- a 20x20 grid, of tile that have x/y coordinate
- a tile can be

  - a wall-tile (all edges)
  - an apple-tile
  - a part of the snake, snake-tile
  - an blank-tile

- the snake

  - is made of 1+ consecutive snake-tiles
  - is always moving in the previous setted direction (each 500ms)
  - the head can take any cardinal direction (NESW)
  - the body follow the head
  - when the head collide an apple-tile
    - the apple disapear
    - the snake grow by 1 snake-tiles
  - when the head collide a wall-tile or snake tile: game over

- apples
  - there is always one in a randow position in the field
  - if it's ate, it disappear a new one pop on a ramdom empty tile
  - if there is no more empty tile: game over

### implementation

#### Window And Walls

Let's try to make a 20x20 window with 4 walls
Sadly, I now nothing in videogame development.
My first reflex is just to draw walls.
Indeed,

```scheme
#lang racket
(require r-cade)
(define (game-loop)
  (cls)
  (begin
    (color 4)
    (rect 0 0 20 1 #:fill #t)))
    ; and so on for all stuff to draw
  (run game-loop grid-size grid-size)
```

will draw on top-left a 1x20 sized rectangle, filled with a braun color.

![rcad rect](./img/17-r-cade_rect.png)

You remember `begin`, that chain functions.
I execute first the function `color` to pick a color in a [16 color palette](https://docs.racket-lang.org/r-cade/index.html?q=r-cade#%28def._%28%28lib._r-cade%2Fmain..rkt%29._color%29%29) (4 = braun) for the next steps.
`rect` takes `x y` coordinates, `h w` sizes, and this strange `#:fill #t`. It's a "fill" unordered named argument (how smart!) that takes the value `True` or `False`: `#t` or `#f` in racket.

I can continue with other walls, apples and snake. But this method is a dead-lock because it don't track anything. It just produce a picture without state, without life.

What I really want is a representation of the state of the game, that can change and be redraw. A grid with the state of all it tiles.

I opt for a grid that is a list of list (row) containing tiles (cell). A tile will be a tuple (a list with few ordered members): (coord-x coorddx tile-type), like `(12 0 "apple")`.

Each game frame of the main loop will draw this grid findind the current state of each tile.

```scheme
;; grid values
(define grid-size 20)
(define grid
  (build-list
   grid-size
   (lambda (y)
     (build-list grid-size (lambda (x) (list x y "blank"))))))
```

Here `build-list n value-as-lambda` create a list of n items with cohesive values. Thoses values are based on a `lamda`: an anonymous and temporary function to call for create the value, and that take the current index as argument. In fact, we operate in nested list to obtain this ful grid of `(x y tile-type)` tuples.

Now, my walls definition:

```scheme
; wall definitions
(define max-grid-index (- grid-size 1))
(define wall-coords
  (let ([top (build-list grid-size (lambda (x)(list x 0)))]
        [bottom (build-list grid-size (lambda (x)(list x max-grid-index)))]
        [left (build-list (- grid-size 2) (lambda (y)(list 0 (+ y 1))))]
        [right (build-list (- grid-size 2) (lambda (y)(list max-grid-index (+ y 1))))]

        )
    (append top bottom left right)))
```

Nothing new exept this `append` used to concatenate lists.
But were is the glue? How to update the grid ?

In functional programming in general, you avoid state, mutability and side effect. But my approach of this game imply a changing state: the grid.
`(set! old new)` is the way to procede. `for-each`, `list-update`, `list-set` is stuff coming form [list docs](https://docs.racket-lang.org/reference/pairs.html)

```scheme
; update 1 tile
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

; update several tiles
(define (update-tiles coords val)
  (for-each
   (lambda (coord)(update-tile coord val))
   coords))
```

What we need know is some stuff to draw that on the window:

```scheme
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

; game definitions
(define (game-loop)
  (cls)
  (begin
    (draw-grid grid)))

; procedure
(update-tiles wall-coords "wall")
(run game-loop grid-size grid-size)
```

We just produce braun rectangles (or other colors) for each related info we have in the grid.

![rcad walls](./img/18-r-cade_walls.png)

> hum... 8:12 PM. Let's take a final dinner-pause. I feel some doubts about my capacity to end up this challenge...
> But hope drive me !
> I want to brag in work tomorrow, so failing is not an option.

#### The Snake

I wanted a centered snake, so I change my grid size to 21. The center should be (10 10) and I calculate it (because I want to be able to change the size of wy grid).

If I want it to move 2 times per seconds, I have to change the framerate.

```scheme
(define grid-size 21)
; ...
; snake definitions
(define snake-coords
  (let ([val (round (- ( / grid-size 2) 1))])
    (list val val)))

; procedure
(update-tiles wall-coords "wall")
(update-tile snake-coords "snake")
(run game-loop grid-size grid-size #:fps 2)
```

![rcad walls](./img/19-r-cade_snake.png)

Make it move will happen just after each draw, for the next. What we want to do is make the head of the snake follow a direction each redraw, until an event.

For now, it simply goes up:

```scheme
(define (snake-position-update)
  (begin (update-tile snake-coords "empty")
         (let [(new-coords (list (list-ref snake-coords 0) (- (list-ref snake-coords 1) 1)))]
           (set! snake-coords new-coords)
           (update-tile new-coords "snake"))))

;...

; game definitions
(define (game-loop)
  (cls)
  (draw-grid grid)
  (snake-position-update))
```

What about a collision with a wall ?

## stuff

That's it, simply use the `list` identifier.
The next thing to know to be able to memorize a list of things to do,
is of course creating a list a `pict`:

- `(list (circle 10) (rectangle 10 10) (disk 10))`
- -`

## Resources to go further

I just discovered this language and this world, but after this day about racket,
I dive a little more into podcast and videos. Here is what I found:

- [Language-Oriented Programming with Racket - Matthias Felleisen](https://www.youtube.com/watch?v=z8Pz4bJV3Tk)
