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
)
