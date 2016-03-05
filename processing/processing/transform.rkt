#lang racket

(provide (all-defined-out))

(require rosetta
         "runtime-bindings.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Transform
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define/types (intersection [Object s1] [Object s2] -> Object)
  (intersection s1 s2))

(define/types (subtraction [Object s1] [Object s2] -> Object)
  (subtraction s1 s2))

(define/types (empty-shape -> Object)
  (empty-shape))

(define/types (union [Object s1] [Object s2] -> Object)
  (union s1 s2))

(define/types (union [Object s1] [Object s2] [Object s3] -> Object)
  (union s1 s2 s3))

(define/types (union [Object s1] [Object s2] [Object s3] [Object s4] -> Object)
  (union s1 s2 s3 s4))

(define/types (union [Object s1] [Object s2] [Object s3] [Object s4] [Object s5] -> Object)
  (union s1 s2 s3 s4 s5))

(define/types (union [Object s1] [Object s2] [Object s3] [Object s4] [Object s5] [Object s6] -> Object)
  (union s1 s2 s3 s4 s5 s6))

(define/types (spline [Object a] -> Object)
  (spline (vector->list a)))

(define/types (spline [Object p1] [Object p2] -> Object)
  (spline (list p1 p2)))

(define/types (spline [Object p1] [Object p2] [Object p3] -> Object)
  (spline (list p1 p2 p3)))

(define/types (spline [Object p1] [Object p2] [Object p3] [Object p4] -> Object)
  (spline (list p1 p2 p3 p4)))

(define/types (spline [Object p1] [Object p2] [Object p3] [Object p4] [Object p5] -> Object)
  (spline (list p1 p2 p3 p4 p5)))

(define/types (loft [Object a] [Object b] -> Object)
  (loft (list a b)))

(define/types (loft [Object a] [Object b] [Object c] -> Object)
  (loft (list a b c)))

(define/types (loft [Object a] [Object b] [Object c] [Object d] -> Object)
  (loft (list a b c d)))

(define/types (sweep [Object a] [Object b] -> Object)
  (sweep a b))

(define/types (division [float min] [float max] [int n] -> Object)
  (list->vector (division min max n)))

(define/types (surface-grid [Object a] -> Object)
  (surface-grid
   (map vector->list
        (vector->list a))))

(define/types (thicken [Object a] [Object f] -> Object)
  (thicken a f))

(define/types (layer [String a] -> void)
  (layer a))
