                                        ; Stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))
(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))
(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))
(define (display-stream s) (stream-for-each display-line s))
(define (display-line x) (newline) (display x))
                                        ; implementation
(define (memo-proc proc)
  (let ((already-run? false) (result false))
    (lambda ()
      (if (not already-run?)
          (begin (set! result (proc))
                 (set! already-run? true)
                 result)
          result))))
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))
                                        ; extra
(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream low
                   (stream-enumerate-interval (+ low 1) high))))
(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (begin (apply proc (map stream-car argstreams))
             (apply stream-map (cons proc (map stream-cdr argstreams))))))
(define (add-streams s1 s2) (stream-map + s1 s2))
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

;; exercise 3.59
(define (integrate-series s)
  (stream-map / s integers))
(define cosine-series
  (cons-stream 1 (integrate-series (scale-stream sine-series -1))))
(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;; exercise 3.60
