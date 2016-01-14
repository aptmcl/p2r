#lang racket/base

(require racket/math)
(provide (all-defined-out))

(require (prefix-in % rosetta)
         "runtime-bindings.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3D Primitives
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; xyz : float float float -> xyz
;;; coordinate abstraction
(define/types (xyz [float x] [float y] [float z] -> Object)
  (%xyz x y z))

(define/types (xy [float x] [float y] -> Object)
  (%xyz x y 0.0))

(define/types (translate [float dx] [float dy] -> void)
  (%current-cs (%translated-cs dx dy 0 (%current-cs)))
  (void))

(define/types (rotate [float phi] -> void)
  (%current-cs (%z-rotated-cs phi (%current-cs)))
  (void))

(define/types (scale [float f] -> void)
  (%current-cs (%scaled-cs f (%current-cs)))
  (void))

(define/types (radians [float a] -> float)
  (/ (* a 2 pi) 360))

;;Text Size

(define text-size (make-parameter 12)) ;;Ver no Processing qual o default

(define/types (text-size [float s] -> void)
  (text-size s)
  (void))

(define/types (text [String str] [float x] [float y] -> Object)
  (%text str (%xy x y) (text-size)))

;;Fill&Stroke

(struct color
  (r
   g
   b
   a))

(define fill-color (make-parameter (color 255 255 255 255)))

(define/types (fill [float gray] -> void)
  (fill-color (color gray gray gray 255))
  (void))

(define/types (fill [float gray] [float alpha] -> void)
  (fill-color (color gray gray gray alpha))
  (void))

(define/types (fill [float red] [float green] [float blue] -> void)
  (fill-color (color red green blue 255))
  (void))

(define/types (fill [float red] [float green] [float blue] [float alpha] -> void)
  (fill-color (color red green blue alpha))
  (void))

(define/types (nofill -> void)
  (fill-color #f)
  (void))

;;Idem for stroke

(define stroke-color (make-parameter (color 255 255 255 255)))

(define/types (stroke [float gray] -> void)
  (stroke-color (color gray gray gray 255))
  (void))

(define/types (stroke [float gray] [float alpha] -> void)
  (stroke-color (color gray gray gray alpha))
  (void))

(define/types (stroke [float red] [float green] [float blue] -> void)
  (stroke-color (color red green blue 255))
  (void))

(define/types (stroke [float red] [float green] [float blue] [float alpha] -> void)
  (stroke-color (color red green blue alpha))
  (void))

(define/types (nostroke -> void)
  (stroke-color #f)
  (void))

(define/types (smooth [int level] -> void)
  (void))

(define/types (nosmooth -> void)
  (void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2D Shapes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define/types (arc [Object point] [float width] [float height] [float start] [float stop] -> void)
  (when (fill-color)
    (%surface-arc point width start (- stop start)))
  (when (stroke-color)
    (%arc point width start (- stop start))))

(define/types (ellipse [Object point] [float c] [float d] -> void)
  (when (fill-color)
    (if (= c d)
        (%surface-circle point c)
        (%surface-ellipse point c d)))
  (when (stroke-color)
    (if (= c d)
        (%circle point c)
        (%ellipse point c d))))

(define/types (surface-circle [Object point] [float c] -> void)
  (%surface-circle point c))

(define/types (line [Object p1] [Object p2] -> void)
  (%line p1 p2))

(define/types (point [Object p] -> void)
  (%point p))

(define/types (quad [Object p1] [Object p2] [Object p3] [Object p4] -> void)
  (%polygon p1 p2 p3 p4))

(define/types (triangle [Object p1] [Object p2] [Object p3] -> void)
  (%polygon p1 p2 p3))

(define/types (rect [Object p1] [float c] [float d] -> void)
  (%rectangle p1 c d))

(define/types (surface-rect [Object p1] [float c] [float d] -> void)
  (%surface-rectangle p1 c d))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Curves
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#|
 |(define-syntax bezier
 |  (syntax-rules ()
 |    [(_ x1 y1 x2 y2 x3 y3 x4 y4)
 |     (error "bezier: Not implemented yet!")]
 |    [(_ x1 y1 z1 x2 y2 z2 x3 y3 z3 x4 y4 z4)
 |     (error "bezier: Not implemented yet!")]))
 |
 |(define (bezierDetail detail)
 |  (error "bezierDetail: Not implemented yet!"))
 |
 |(define (bezierPoint a b c d t)
 |  (error "bezierPoint: Not implemented yet!"))
 |
 |(define (bezierTangent a b c d t)
 |  (error "bezierTangent: Not implemented yet!"))
 |
 |(define-syntax curve
 |  (syntax-rules ()
 |    [(_ x1 y1 x2 y2 x3 y3 x4 y4)
 |     (error "curve: Not implemented yet!")]
 |    [(_ x1 y1 z1 x2 y2 z2 x3 y3 z3 x4 y4 z4)
 |     (error "curve: Not implemented yet!")]))
 |
 |(define (curveDetail detail)
 |  (error "curveDetail: Not implemented yet!"))
 |
 |(define (curvePoint a b c d t)
 |  (error "curvePoint: Not implemented yet!"))
 |
 |(define (curveTangent a b c d t)
 |  (error "Not implemented yet!"))
 |
 |(define (curveTightness tightness)
 |  (error "curveTightness: Not implemented yet!"))
 |#



(define/types (add-c [Object p0] [Object p1] -> Object)
  (%+c p0 p1))

(define/types (sub-c [Object p0] [Object p1] -> Object)
  (%-c p0 p1))

(define/types (mul-c [Object p] [float r] -> Object)
  (%*c p r))

(define/types (div-c [Object p] [float r] -> Object)
  (%/c p r))

(define/types (cx [Object p] -> float)
  (%cx p))

(define/types (cy [Object p] -> float)
  (%cy p))

(define/types (cz [Object p] -> float)
  (%cy p))

(define/types (intermediate-point [Object p0] [Object p1] -> Object)
  (%+c p0 (%*c (%-c p1 p0) 0.5)))

(define/types (intermediate-point [Object p0] [Object p1] [float f] -> Object)
  (%+c p0 (%*c (%-c p1 p0) f)))

(define/types (distance [Object p0] [Object p1] -> float)
  (%distance p0 p1))


(define (normal-poligono pts)
  (%unitize
   (produtos-cruzados
    (append pts (list (car pts))))))

(define (produtos-cruzados pts)
  (if (null? (cdr pts))
      (%xyz 0 0 0)
      (%v+v (produto-cruzado (car pts) (cadr pts))
            (produtos-cruzados (cdr pts)))))

(define (produto-cruzado p0 p1)
  (%v*v p0 p1))

(define (normal-quadrangulo p0 p1 p2 p3)
  (normal-poligono (list p0 p1 p2 p3)))

(define (media a b)
  (/ (+ a b) 2.0))

(define (media-pontos p0 p1)
  (%xyz (media (%cx p0) (%cx p1))
        (media (%cy p0) (%cy p1))
        (media (%cz p0) (%cz p1))))

(define (centro-quadrangulo p0 p1 p2 p3)
  (media-pontos
   (media-pontos p0 p2)
   (media-pontos p1 p3)))

(define/types (quad-center [Object p0] [Object p1] [Object p2] [Object p3] -> Object)
  (centro-quadrangulo p0 p1 p2 p3))

(define/types (quad-normal [Object p0] [Object p1] [Object p2] [Object p3] -> Object)
  (normal-quadrangulo p0 p1 p2 p3))


;;; xyz : float float float -> xyz
;;; coordinate abstraction
(define/types (pol [float r] [float ang] -> Object)
  (%pol r ang))

;;; xyz : float float float -> xyz
;;; coordinate abstraction
(define/types (cyl [float r] [float th] [float fi] -> Object)
  (%cyl r th fi))


(define/types (regular-polygon [int s] [Object p] [float r] [float a] [boolean i]-> Object)
  (%regular-polygon s p r a i))

(define/types (surface [Object s]-> Object)
  (%surface s))


;;; box : -> void
;;; unary rectangular cuboid from the bottom-left corner
(define/types (box -> Object)
  (%box))

;;; box : xyz xyz -> void
;;; rectagular cuboid from the bottom-left corner to opposite top corner
(define/types (box [Object p1] [Object p2] -> Object)
  (%box p1 p2))

;;; box : xyz float float float -> void
;;; rectagular cuboid from the bottom-left with length, witdh and height
(define/types (box [Object p1] [float dx] [float dy] [float dz] -> Object)
  (%box p1 dx dy dz))

;;; right-cuboid : xyz float float float -> void
;;; cuboid base centered on a point
(define/types (right-cuboid [Object p1] [float dx] [float dy] [float dz] -> Object)
  (%right-cuboid p1 dx dy dz))

;;; cuboid : xyz ... xyz -> void
;;; cuboid based on 4 top vertices and 4 bot vertices
(define/types (cuboid [Object b1] [Object b2] [Object b3] [Object b4] [Object t1] [Object t2] [Object t3] [Object t4] -> Object)
  (%cuboid b1 b2 b3 b4 t1 t2 t3 t4))

;;; sphere : xyz float -> void
;;; sphere given the centroid point and the radius
(define/types (sphere [Object p] [float r] -> Object)
  (%sphere p r))

;;; cylinder : xyz float float -> void
;;; cylinder given base center, radius and height
(define/types (cylinder [Object p] [float r] [float h] -> Object)
  (%cylinder p r h))

;;; cylinder : xyz float float -> void
;;; cylinder given base center, radius and height
(define/types (cylinder [Object b] [float r] [Object t] -> Object)
  (%cylinder b r t))

;;; cone : xyz float float -> void
;;; cone given base center, radius and height
(define/types (cone [Object b] [float r] [float h] -> Object)
  (%cone b r h))

;;; cone : xyz float xyz -> void
;;; cone given the base center, radius and top center
(define/types (cone [Object b] [float r] [Object t] -> Object)
  (%cone b r t))

;;; cone-frustum : xyz float float float -> void
;;; cone-frustum given the base center, bottom radius , height and top radius
(define/types (cone-frustum [Object b] [float r1] [float h] [float r2] -> Object)
  (%cone-frustum b r1 h r2))

;;; cone-frustum : xyz float xyz float -> void
;;; given the base center, bottom radius , top center and top radius
(define/types (cone-frustum [Object b] [float r1] [Object t] [float r2] -> Object)
  (%cone-frustum b r1 t r2))

;;; pyramid : int xyz float float float -> void
;;; takes the number of sides, base point, base radius, initial angle and height
(define/types (pyramid [float n] [Object p] [float r] [float ang] [float h] -> Object)
  (%regular-pyramid n p r ang h))

;;; pyramid : int xyz float xyz float -> void
;;; takes the number of sides, base point, base radius, initial angle and top point
(define/types (pyramid [float n] [Object p] [float r] [float ang] [Object t] -> Object)
  (%regular-pyramid n p r ang t))

;;; pyramid-frustum : int xyz float float float float -> void
;;; takes the number of sides, base point, base radius, initial angle, height, and top radius
(define/types (pyramid-frustum [float n] [Object p] [float r] [float ang] [float h] [float r2] -> Object)
  (%regular-pyramid-frustum n p r ang h r2))

;;; pyramid-frustum : int xyz float xyz float float -> void
;;; takes the number of sides, base point, base radius, initial angle, top point, and top radius
(define/types (pyramid-frustum [float n] [Object p] [float r] [float ang] [Object t] [float r2] -> Object)
  (%regular-pyramid-frustum n p r ang t r2))

;;; irregular-pyramid : (vector/of xyz) xyz -> void
;;; takes a list of points that define the base and the location of the apex
(define/types (irregular-pyramid [Object lst] [Object apex] -> Object)
  (%irregular-pyramid  (vector->list lst) apex #t))

;;; prism : int xyz float float float -> void
;;; takes the number of sides, base point, base radius, initial angle, height.
(define/types (prism [float n] [Object p] [float r] [float ang] [float h] -> Object)
  (%regular-prism n p r ang h))

;;; prism : int xyz float float xyz -> void
;;; takes the number of sides, base point, base radius, initial angle, top point.
(define/types (prism [float n] [Object p] [float r] [float ang] [Object t] -> Object)
  (%regular-prism n p r ang t))

;;; irregular-prism : (vector/of xyz) xyz -> void
;;; takes a list of points that define the base and the location of the apex
#;
(define/types (irregular-prism [Object lst] [Object apex] -> Object)
  (%irregular-prism (vector->list lst) apex))

;;; irregular-prism : (vector/of xyz) xyz -> void
;;; takes the center point of the torus, the torus radius and the section radius
(define/types (torus  [Object p] [float r1] [float r2] -> Object)
  (%torus p r1 r2))

