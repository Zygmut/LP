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
  (putprop 'spiro 32 'rpetit)
  (putprop 'spiro 3 'punt)
  (putprop 'spiro 0 'inici)
  (putprop 'spiro 1.5 'escala)
  (putprop 'spiro t 'interior)
  (putprop 'spiro 0 'x)
  (putprop 'spiro 0 'y)
  (putprop 'spiro 0.2 'pas)
  ; Aditional variables
  (putprop 'spiro 100 'segments)
  (putprop 'spiro 320 'x-center)
  (putprop 'spiro 187 'y-center)
  (putprop 'spiro -90 'angle-offset)
)
(guarda-informacio)

(defun radigran (r)
  (putprop 'spiro r 'rgran)
  (cercle
    (get 'spiro 'x)
    (get 'spiro 'y)
    (get 'spiro 'rgran)
    (get 'spiro 'segments)
  )
)

(defun radipetit (r)
  (putprop 'spiro r 'rpetit)
  (cercle
    (* (sin (radians (get 'spiro 'inici))) (- (get 'spiro 'rgran) (get 'spiro 'rpetit)))
    (* (cos (radians (get 'spiro 'inici))) (- (get 'spiro 'rgran) (get 'spiro 'rpetit)))
    (get 'spiro 'rpetit)
    (get 'spiro 'segments)
  )
)

(defun punt (p)
  (putprop 'spiro p 'punt)
)

(defun inici (a)
  (putprop 'spiro a 'inici)
)

(defun escala (e)
  (putprop 'spiro e 'escala)
)

(defun posicio (x-pos y-pos)
  (putprop 'spiro x-pos 'x)
  (putprop 'spiro y-pos 'y)
)

(defun cercle (x y radi segments)
  (mou (+ x radi) y)
  (cercle-step x y radi (/ 360 segments) 0))

(defun cercle-step (x y radi angle-delta angle)
  (cond ((< angle 360)
         (pinta (+ x (* radi (cos (radians (+ angle angle-delta)))))
                (+ y (* radi (sin (radians (+ angle angle-delta))))))
         (cercle-step x y radi angle-delta (+ angle angle-delta)))
        (t t)))

(defun mou (x y)
  (move (realpart (round (+ (get 'spiro 'x-center) (* (get 'spiro 'escala) x))))
  (realpart (round (+ (get 'spiro 'y-center) (* (get 'spiro 'escala) y))))))

(defun pinta (x y)
  (draw (realpart (round (+ (get 'spiro 'x-center) (* (get 'spiro 'escala) x))))
        (realpart (round (+ (get 'spiro 'y-center) (* (get 'spiro 'escala) y))))))

(defun radians (degrees)
  (/ (* degrees (* 2 pi)) 360))

(defun reduir (m n)
  (list (/ m (gcd m n)) (/ n (gcd m n)))
)

; Part 2

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

(defun rotate-x(x y angle)
  (set 'angle-abs (+ angle (get 'spiro 'angle-offset)))
  (+ (* x (cos (radians angle-abs))) (* y (sin (radians angle-abs))))
)

(defun rotate-y(x y angle)
  (set 'angle-abs (+ angle (get 'spiro 'angle-offset)))
  (+ (* (- x) (sin (radians angle-abs))) (* y (cos (radians angle-abs))))
)

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

(defun roda ()
  (spiro
    (get 'spiro 'rgran)
    (get 'spiro 'rpetit)
    (get 'spiro 'punt)
    (get 'spiro 'pas)
    (get 'spiro 'inici)
  )
)

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

(defun spiro-list (l)
    (spiro (nth 0 l) (nth 1 l) (nth 2 l) (nth 3 l) (nth 4 l))
)

(defun spiros (l)
  (cond ((null (cdr l)) (spiro-list (car l)))
        (t  (spiro-list (car l)) 
             (spiros (cdr l)))
  )
)