(defun negre ()
  (color 0 0 0))

(defun vermell ()
  (color 255 0 0))

(defun verd ()
  (color 0 255 0))

(defun blau ()
  (color 0 0 255))

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
  (putprop 'spiro 50 'rpetit)
  (putprop 'spiro 3 'punt)
  (putprop 'spiro 0 'inici)
  (putprop 'spiro 1.8 'escala)
  (putprop 'spiro t 'interior)
  (putprop 'spiro 0 'x)
  (putprop 'spiro 0 'y)
  (putprop 'spiro 0.2 'pas)
  (putprop 'spiro 320 'x-center)
  (putprop 'spiro 187 'y-center)
)

(defun radigran (r)
  (putprop 'spiro 'r 'rgran)
  ; TODO draw circle
)

(defun radipetit (r)
  (putprop 'spiro 'r 'rpetit)
  ; TODO draw circle
)

(defun punt (p)
  (putprop 'spiro 'p 'punt)
)

(defun inici (a)
  (putprop 'spiro 'a 'inici)
)

(defun escala (e)
  (putprop 'spiro 'e 'escala)
)

(defun posicio (x-pos y-pos)
  (putprop 'spiro 'x-pos 'x)
  (putprop 'spiro 'y-pos 'y)
)

(defun reduir (m n)

)

(defun cercle (x y radi segments)
  (mou (+ x radi) y)
  (cercle-segment x y radi (/ 360 segments) 0))

(defun cercle-segment (x y radi angle-delta angle)
  (cond ((< angle 360)
         (pinta (+ x (* radi (cos (radians (+ angle angle-delta)))))
                (+ y (* radi (sin (radians (+ angle angle-delta))))))
         (cercle-segment x y radi angle-delta (+ angle angle-delta)))
        (t t)))

(defun mou (x y)
  (move (realpart (round (+ (get 'spiro 'x-center) (* (get 'spiro 'escala) x))))
  (realpart (round (+ (get 'spiro 'y-center) (* (get 'spiro 'escala) y))))))

(defun pinta (x y)
  (draw (realpart (round (+ (get 'spiro 'x-center) (* (get 'spiro 'escala) x))))
        (realpart (round (+ (get 'spiro 'y-center) (* (get 'spiro 'escala) y))))))

(defun radians (degrees)
  (/ (* degrees (* 2 pi)) 360))

