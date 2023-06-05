; Sets the color to black (RGB: 0, 0, 0)
(defun negre ()
  (color 0 0 0))

; Sets the color to red (RGB: 255, 0, 0)
(defun vermell ()
  (color 255 0 0))

; Sets the color to green (RGB: 0, 255, 0)
(defun verd ()
  (color 0 255 0))

; Sets the color to blue (RGB: 0, 0, 255)
(defun blau ()
  (color 0 0 255))

; Stores various properties related to the 'spiro' object, such as coordinates, sizes, and additional variables.
(defun guarda-informacio ()
  (putprop
    'spiro
    '(
      (150 105)
      (144 96)
    )
    'grans)
  (putprop
    'spiro
    '(
      (84 35 56)
      (80 33 53)
      (75 31 50)
      (72 29 48)
      (63 25 42)
      (60 23 40)
      (56 21 37)
      (52 19 35)
      (48 17 32)
      (45 16 30)
      (42 14 28)
      (40 13 27)
      (32 9 21)
      (30 8 20)
      (24 5 16)
    )
    'petits)
  (putprop 'spiro 150 'rgran)
  (putprop 'spiro 32 'rpetit)
  (putprop 'spiro 3 'punt)
  (putprop 'spiro 0 'inici)
  (putprop 'spiro 1.5 'escala)
  (putprop 'spiro t 'interior)
  (putprop 'spiro 320 'x)
  (putprop 'spiro 187 'y)
  (putprop 'spiro 0.2 'pas)
  ; Aditional variables
  (putprop 'spiro 620 'win-width)
  (putprop 'spiro 374 'win-height)
  (putprop 'spiro 100 'segments)
  (putprop 'spiro -90 'angle-offset)
)
(guarda-informacio)

; Draws a circle with the specified radius using the 'cercle' function, using the 'rgran' property of the 'spiro' object.
(defun radigran (r)
  (putprop 'spiro r 'rgran)
  (cercle
    0
    0
    (get 'spiro 'rgran)
    (get 'spiro 'segments)
  )
)

; Draws a circle with the specified radius using the 'cercle' function, using the 'rpetit' property of the 'spiro' object.
(defun radipetit (r)
  (putprop 'spiro r 'rpetit)
  (cercle
    (* (sin (radians (get 'spiro 'inici))) (- (get 'spiro 'rgran) (get 'spiro 'rpetit)))
    (* (cos (radians (get 'spiro 'inici))) (- (get 'spiro 'rgran) (get 'spiro 'rpetit)))
    (get 'spiro 'rpetit)
    (get 'spiro 'segments)
  )
)

; Sets the 'punt' property of the 'spiro' object to the provided value.
(defun punt (p)
  (putprop 'spiro p 'punt)
)

; Sets the 'inici' property of the 'spiro' object to the provided value.
(defun inici (a)
  (putprop 'spiro a 'inici)
)

; Sets the 'escala' property of the 'spiro' object to the provided value.
(defun escala (e)
  (putprop 'spiro e 'escala)
)

; Sets the 'x' and 'y' coordinates of the 'spiro' object to the provided values.
(defun posicio (x-pos y-pos)
  (putprop 'spiro x-pos 'x)
  (putprop 'spiro y-pos 'y)
)

; Updates the 'x' and 'y' coordinates of the 'spiro' object by adding the provided offsets to the current coordinates.
(defun posicio-rel (x-off y-off)
  (putprop 'spiro (+ x-off (get 'spiro 'x)) 'x)
  (putprop 'spiro (+ y-off (get 'spiro 'y)) 'y)
)

; Draws a circle with the specified center coordinates, radius, and number of segments using the 'pinta' function.
(defun cercle (x y radi segments)
  (mou (+ x radi) y)
  (cercle-step x y radi (/ 360 segments) 0))

; Recursive helper function for drawing a circle with the specified center coordinates, radius, angle increment, and current angle using the 'pinta' function.
(defun cercle-step (x y radi angle-delta angle)
  (cond ((< angle 360)
         (pinta (+ x (* radi (cos (radians (+ angle angle-delta)))))
                (+ y (* radi (sin (radians (+ angle angle-delta))))))
         (cercle-step x y radi angle-delta (+ angle angle-delta)))
        (t t)))

; Moves the 'spiro' object to the specified coordinates by updating the 'x' and 'y' properties.
(defun mou (x y)
  (move (realpart (round (+ (get 'spiro 'x) (* (get 'spiro 'escala) x))))
  (realpart (round (+ (get 'spiro 'y) (* (get 'spiro 'escala) y))))))

; Draws a point at the specified coordinates by updating the 'x' and 'y' properties.
(defun pinta (x y)
  (draw (realpart (round (+ (get 'spiro 'x) (* (get 'spiro 'escala) x))))
        (realpart (round (+ (get 'spiro 'y) (* (get 'spiro 'escala) y))))))

; Converts the provided angle in degrees to radians.
(defun radians (degrees)
  (/ (* degrees (* 2 pi)) 360))

; Reduces the provided fraction by finding the greatest common divisor (GCD) and dividing both numerator and denominator.
(defun reduir (m n)
  (list (/ m (gcd m n)) (/ n (gcd m n)))
)

; Part 2

; Calculates the x-coordinate of a point on a hypocycloid using the provided angle, distance, and radii.
(defun get-x-hipo (angle dist rgran rpetit)
  (+
    (*
       (- rgran rpetit)
       (cos (/ (* angle rpetit) rgran))
    )
    (*
      dist
      (cos (* angle (- 1 (/ rpetit rgran))))
    )
  )
)

; Calculates the y-coordinate of a point on a hypocycloid using the provided angle, distance, and radii.
(defun get-y-hipo (angle dist rgran rpetit)
  (-
    (*
       (- rgran rpetit)
       (sin (/ (* angle rpetit) rgran))
    )
    (*
      dist
      (sin (* angle (- 1 (/ rpetit rgran))))
      )
  )
)

; Calculates the x-coordinate of a point on an epicycloid using the provided angle, distance, and radii.
(defun get-x-epi (angle dist rgran rpetit)
  (-
    (*
       (+ rgran rpetit)
       (cos (/ (* angle rpetit) rgran))
    )
    (*
      dist
      (cos (* angle (+ 1 (/ rpetit rgran))))
    )
  )
)

; Calculates the y-coordinate of a point on an epicycloid using the provided angle, distance, and radii.
(defun get-y-epi (angle dist rgran rpetit)
  (-
    (*
       (+ rgran rpetit)
       (sin (/ (* angle rpetit) rgran))
    )
    (*
      dist
      (sin (* angle (+ 1 (/ rpetit rgran))))
    )
  )
)

; Rotates the coordinates (x, y) around the origin by the specified angle.
(defun rotate-x(x y angle)
  (set 'angle-abs (+ angle (get 'spiro 'angle-offset)))
  (+ (* x (cos (radians angle-abs))) (* y (sin (radians angle-abs))))
)

; Rotates the coordinates (x, y) around the origin by the specified angle.
(defun rotate-y(x y angle)
  (set 'angle-abs (+ angle (get 'spiro 'angle-offset)))
  (+ (* (- x) (sin (radians angle-abs))) (* y (cos (radians angle-abs))))
)

; Draws a spirograph pattern using the specified parameters, such as radii, distance, increment, and initial angle.
(defun spirograph (pases rgran rpetit dist inc inici)
    (cond ((get 'spiro 'interior)
            (set 'x (get-x-hipo pases dist rgran rpetit))
            (set 'y (get-y-hipo pases dist rgran rpetit))
            (mou (rotate-x x y inici) (rotate-y x y inici))
            (spirograph-interior-step pases rgran rpetit dist inc inici)
          )
          (t
            (set 'x (get-x-epi pases dist rgran rpetit))
            (set 'y (get-y-epi pases dist rgran rpetit))
            (mou (rotate-x x y inici) (rotate-y x y inici))
            (spirograph-exterior-step pases rgran rpetit dist inc inici)
          )
    )
)

; Recursive helper function for drawing a spirograph pattern on the interior using the specified parameters.
(defun spirograph-interior-step (pases rgran rpetit dist inc inici)
  (cond ((< pases 0) t)
        (t
          (set 'x (get-x-hipo pases dist rgran rpetit))
          (set 'y (get-y-hipo pases dist rgran rpetit))
          (pinta (rotate-x x y inici) (rotate-y x y inici))
          (spirograph-interior-step (- pases inc) rgran rpetit dist inc inici)
        )
  )
)

; Recursive helper function for drawing a spirograph pattern on the exterior using the specified parameters.
(defun spirograph-exterior-step (pases rgran rpetit dist inc inici)
  (cond ((< pases 0) t)
        (t
          (set 'x (get-x-epi pases dist rgran rpetit))
          (set 'y (get-y-epi pases dist rgran rpetit))
          (pinta (rotate-x x y inici) (rotate-y x y inici))
          (spirograph-exterior-step (- pases inc) rgran rpetit dist inc inici)
        )
  )
)

; Draws a spirograph pattern using the specified radii, point, increment, and initial angle.
(defun spiro (rgran rpetit p inc inici)
  (set 'petit-info (find-if (lambda (row) (equal rpetit (car row))) (get 'spiro 'petits)))
  (set 'dents (car petit-info))
  (set 'forats (cadr petit-info))

  (spirograph
    (/ (* 2 pi (cadr (reduir rgran rpetit))) inc)
    rgran
    rpetit
   (* (+ 1 (- forats p)) (/ dents (+ 1 forats)))
    inc
    inici
  )
)

; Part 3

; Draws a spirograph pattern using the current properties of the 'spiro' object.
(defun roda ()
  (spiro
    (get 'spiro 'rgran)
    (get 'spiro 'rpetit)
    (get 'spiro 'punt)
    (get 'spiro 'pas)
    (get 'spiro 'inici)
  )
)

; Draws a spirograph pattern for the specified number of revolutions using the current properties of the 'spiro' object.
(defun roda-voltes (n)
  (set 'petit-info (find-if (lambda (row) (equal (get 'spiro 'rpetit) (car row))) (get 'spiro 'petits)))
  (set 'dents (car petit-info))
  (set 'forats (cadr petit-info))

  (spirograph
    (/ (* 2 pi (- n 1)) (get 'spiro 'pas))
    (get 'spiro 'rgran)
    (get 'spiro 'rpetit)
   (* (+ 1 (- forats (get 'spiro 'punt))) (/ dents (+ 1 forats)))
    (get 'spiro 'pas)
    (get 'spiro 'inici)
  )
)

; Draws a spirograph pattern for the specified number of revolutions using the provided radii, point, increment, and initial angle.
(defun spiro-voltes (voltes rgran rpetit p inc inici)
  (set 'petit-info (find-if (lambda (row) (equal rpetit (car row))) (get 'spiro 'petits)))
  (set 'dents (car petit-info))
  (set 'forats (cadr petit-info))

  (spirograph
    (/ (* 2 pi (- voltes 1)) inc)
    rgran
    rpetit
   (* (+ 1 (- forats p)) (/ dents (+ 1 forats)))
    inc
    inici
  )
)

; Draws multiple spirograph patterns based on the list of parameter sets.
(defun spiros (l)
  (cond ((null (cdr l)) (apply 'spiro (car l)))
        (t  (apply 'spiro (car l))
             (spiros (cdr l)))
  )
)

(defun dibuix ()
  (set 'old-escala (get 'spiro 'escala))
  (set 'old-x (get 'spiro 'x))
  (set 'old-y (get 'spiro 'y))

  (set 'margin 70)
  (set 'x-off 160)
  (set 'y-off 110)

  (cls)
  (escala 0.5)

  (posicio margin margin)
  (figura1)
  (posicio-rel x-off 0)
  (figura2)
  (posicio-rel x-off 0)
  (figura3)
  (posicio-rel x-off 0)
  (figura4)
  (posicio margin margin)
  (posicio-rel 0 y-off)
  (figura5)
  (posicio-rel x-off 0)
  (figura6)
  (posicio-rel x-off 0)
  (figura7)
  (posicio-rel x-off 0)
  (figura8)
  (posicio margin margin)
  (posicio-rel 0 (* 2 y-off))
  (figura9)
  (posicio-rel x-off 0)
  (figura10)
  (posicio-rel x-off 0)
  (figura11)
  (posicio-rel x-off 0)
  (figura12)

  (negre)
  (escala old-escala)
  (posicio old-x old-y)
)

(defun figura1 ()
  (vermell)
  (spiros '((105 63 1 0.5 0)
    (105 63 3 0.5 0)
    (105 63 5 0.5 0)))
  (verd)
  (spiros '((105 63 7 0.5 0)
    (105 63 9 0.5 0)
    (105 63 11 0.5 0)))
  (blau)
  (spiros '((105 63 13 0.5 0)
    (105 63 15 0.5 0)
    (105 63 17 0.5 0)))
)

(defun figura2 ()
  (blau)
  (spiros '((94 60 17 0.5 129)
    (94 56 14 0.5 57)
    (105 60 5 0.5 18)))
  (vermell)
  (spiros '((105 40 12 0.5 249)
    (105 32 3 0.5 279)
    (94 48 7 0.5 169)))
  (negre)
  (spiros '((105 75 9 0.5 162)
    (105 42 1 0.5 263)
    (105 24 5 0.5 15)))
)

(defun figura3 ()
  (blau)
  (spiros '((105 24 17 0.5 160)
    (94 72 9 0.5 337)
    (105 30 11 0.5 91)))
  (verd)
  (spiros '((94 42 12 0.5 36)
    (94 45 3 0.5 67)
    (105 24 9 0.5 223)))
  (vermell)
  (spiros '((105 48 13 0.5 58)
    (105 80 4 0.5 172)
    (94 30 7 0.5 253)))
)

(defun figura4 ()
  (vermell)
  (spiros '((94 75 15 0.5 171)
    (94 75 15 0.5 139)
    (105 72 9 0.5 70)))
  (verd)
  (spiros '((105 48 16 0.5 217)
    (105 72 16 0.5 78)
    (105 42 17 0.5 323)))
  (blau)
  (spiros '((94 84 1 0.5 199)
    (105 32 14 0.5 113)
    (105 45 13 0.5 76)))
)

(defun figura5 ()
  (verd)
  (spiros '((105 30 6 0.5 183)
    (105 72 5 0.5 109)
    (94 48 1 0.5 7)))
  (negre)
  (spiros '((105 48 2 0.5 113)
    (94 40 17 0.5 13)
    (105 32 12 0.5 146)))
  (negre)
  (spiros '((94 84 8 0.5 120)
    (94 30 13 0.5 338)
    (94 84 13 0.5 27)))
)

(defun figura6 ()
  (negre)
  (spiros '((94 40 17 0.5 182)
    (94 60 11 0.5 309)
    (105 60 12 0.5 325)))
  (verd)
  (spiros '((105 80 10 0.5 293)
    (94 48 8 0.5 319)
    (94 56 15 0.5 237)))
  (vermell)
  (spiros '((94 72 9 0.5 26)
    (94 42 12 0.5 199)
    (94 45 8 0.5 167)))
)

(defun figura7 ()
  (verd)
  (spiros '((105 30 9 0.5 55)
    (94 56 1 0.5 162)
    (105 84 6 0.5 115)))
  (negre)
  (spiros '((105 72 14 0.5 232)
    (105 84 16 0.5 60)
    (94 30 12 0.5 279)))
  (vermell)
  (spiros '((105 56 5 0.5 211)
    (105 40 11 0.5 101)
    (94 75 6 0.5 224)))
)

(defun figura8 ()
  (blau)
  (spiros '((105 72 8 0.5 127)
    (94 40 5 0.5 78)
    (94 30 14 0.5 58)))
  (vermell)
  (spiros '((94 45 12 0.5 77)
    (94 56 16 0.5 4)
    (94 80 2 0.5 282)))
  (verd)
  (spiros '((94 24 17 0.5 188)
    (94 24 16 0.5 59)
    (94 75 5 0.5 16)))
)

(defun figura9 ()
  (blau)
  (spiros '((105 48 14 0.5 219)
    (94 52 2 0.5 325)
    (105 72 7 0.5 46)))
  (negre)
  (spiros '((105 42 11 0.5 113)
    (94 84 11 0.5 220)
    (94 60 6 0.5 146)))
  (blau)
  (spiros '((94 72 11 0.5 137)
    (105 72 9 0.5 210)
    (94 52 6 0.5 269)))
)

(defun figura10 ()
  (negre)
  (spiros '((105 24 8 0.5 166)
    (94 52 17 0.5 259)
    (105 60 8 0.5 25)))
  (verd)
  (spiros '((94 60 12 0.5 216)
    (94 75 3 0.5 134)
    (94 24 4 0.5 57)))
  (blau)
  (spiros '((94 45 11 0.5 124)
    (105 80 9 0.5 2)
    (94 40 9 0.5 212)))
)

(defun figura11 ()
  (negre)
  (spiros '((105 63 5 0.5 107)
    (94 32 11 0.5 211)
    (105 24 12 0.5 78)))
  (verd)
  (spiros '((105 24 14 0.5 241)
    (94 63 1 0.5 182)
    (105 75 2 0.5 237)))
  (verd)
  (spiros '((105 32 14 0.5 296)
    (105 42 5 0.5 189)
    (94 56 16 0.5 296)))
)

(defun figura12 ()
  (verd)
  (spiros '((94 75 17 0.5 182)
    (105 42 3 0.5 244)
    (94 48 3 0.5 263)))
  (negre)
  (spiros '((105 84 3 0.5 37)
    (94 32 5 0.5 284)
    (105 72 9 0.5 157)))
  (verd)
  (spiros '((94 60 11 0.5 18)
    (94 48 15 0.5 201)
    (94 24 8 0.5 260)))
)