(require fluxus-017/fluxus-sonotopy)
(init-sonotopy)

(set-waveform-window-size 0.1)

(clear)
(define p (build-ribbon (get-num-waveform-frames)))
(with-primitive p
   (hint-unlit)
   (pdata-map! (lambda (w) .01) "w"))

(every-frame
   (let ([a (waveform)])
       (with-primitive p
           (pdata-index-map!
               (lambda (i p)
                   (vector (* .005 (- i (/ (pdata-size) 2))) (* 1 (vector-ref a i)) 0))
               "p"))))