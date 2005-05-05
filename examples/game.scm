(clear)
(colour (vector 1 1 1))
(collisions 1)
(define speed 0)
(define steer 0)
(define wheel-mass 0.1)
(gravity (vector 0 -2 0))
(surface-params 0.1 0.1 0.5 0.2)

(push)
    (define (build-wheel)
        (colour (vector 0.4 0.2 0.0))
        (scale (vector 0.6 0.6 0.6))
        (rotate (vector 90 0 0))
        (rotate (vector 0 0 90))
        (translate (vector 0 -0.5 0))
        (hint-none)
        (hint-wire)
        (build-cylinder 1 10))
        
    (translate (vector 0 2 0))
  
    (push)
        (colour (vector 0.2 0.2 0.2))
        (scale (vector 1.5 0.5 2.5))
        (define car-body (build-cube))
        (set-mass car-body 0.1)
    (pop)   
    (push)
        (translate (vector 1.1 0 1.5))
        (define back-right-wheel (build-wheel))
        (set-mass back-right-wheel wheel-mass)
    (pop)
    (push)
        (translate (vector -1.1 0 1.5))
        (define back-left-wheel (build-wheel))
        (set-mass back-left-wheel wheel-mass)
    (pop)
    (push)
        (translate (vector 0 -1 -1.5))
        (define front-right-wheel (build-wheel))
        (set-mass front-right-wheel wheel-mass)
    (pop)
    ;(push)
    ;    (translate (vector -1.1 -1 -1.5))
    ;    (define front-left-wheel (build-wheel))
    ;    (set-mass front-left-wheel wheel-mass)
    ;(pop)
   
    (active-box car-body)
    (active-sphere front-right-wheel)
    (active-sphere back-right-wheel)
    ;(active-sphere front-left-wheel)
    (active-sphere back-left-wheel)
    
    (define back-right-joint (build-hinge2joint car-body back-right-wheel (vector 1.1 2 1.5) (vector 0 1 0) (vector 1 0 0)))
    (define back-left-joint (build-hinge2joint car-body back-left-wheel (vector -1.1 2 1.5) (vector 0 1 0) (vector 1 0 0)))
    (define front-right-joint (build-hinge2joint car-body front-right-wheel (vector 0 1 -1.5) (vector 0 1 0) (vector 1 0 0)))
    ;(define front-left-joint (build-hinge2joint car-body front-left-wheel (vector -1.1 1 -1.5) (vector 0 1 0) (vector 1 0 0)))
    
    (joint-param front-right-joint "LoStop" 0)
    (joint-param back-right-joint "LoStop" 0)
    ;(joint-param front-left-joint "LoStop" 0)    
    (joint-param back-left-joint "LoStop" 0)    
    
    (joint-param front-right-joint "HiStop" 0)
    (joint-param back-right-joint "HiStop" 0)
    ;(joint-param front-left-joint "HiStop" 0)
    (joint-param back-left-joint "HiStop" 0)    

    (joint-param back-right-joint "FMax2" 2)
    (joint-param back-left-joint "FMax2" 2)
  
    ;(joint-param front-left-joint "FMax" 2)
    ;(joint-param front-left-joint "HiStop" 0.75)
    ;(joint-param front-left-joint "LoStop" -0.75)
    ;(joint-param front-left-joint "FudgeFactor" 0.1)
    (joint-param front-right-joint "FMax" 0.2)
    (joint-param front-right-joint "HiStop" 0.75)
    (joint-param front-right-joint "LoStop" -0.75)
    (joint-param front-right-joint "FudgeFactor" 0.0)    
(pop)

(define (update)
    (joint-param back-right-joint "Vel2" speed)
    (joint-param back-left-joint "Vel2" speed)
    ;(joint-param front-left-joint "Vel" steer)
    (joint-param front-right-joint "Vel" steer))
    
(define (rand-range min max)
    (+ min (* (flxrnd) (- max min))))
    
(define (build-terrain n)
    (push)
        (colour (vector (flxrnd) (flxrnd) (flxrnd)))
        (translate (vector (rand-range -60 60) 0 (rand-range -60 60)))
        ;(rotate (vector (rand-range 0 360) (rand-range 0 360) (rand-range 0 360)))
        (scale (vector (rand-range 1 5) (rand-range 1 5) (rand-range 1 5)))
        (passive-box (build-cube))
    (pop)
    (if (zero? n)
        1
        (build-terrain (- n 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    

(push)
(translate (vector 0 -0.5 0))
(scale (vector 1000 1 1000))
(texture (load-texture "green.png"))
(build-cube)
(pop)
(ground-plane (vector 0 1 0) 0.5)

(lock-camera car-body)

(build-terrain 100)
;(blur 0.2)

(define (run-loop)
    (update)
    
    (if (key-pressed " ")
        (begin
        (set! speed 0)
        (set! steer 0)))
    
    (if (key-pressed "q")
        (set! speed (+ speed 1)))
    (if (key-pressed "a")
        (set! speed (- speed 1)))
    (if (key-pressed "o")
        (set! steer (- steer 1)))
    (if (key-pressed "p")
        (set! steer (+ steer 1)))
    
    (set! steer (* steer 0.8)))
    
(engine-callback "(run-loop)")
