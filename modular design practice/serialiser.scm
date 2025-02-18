
(define (make-account balance)
(define (withdraw amount)
(if (>= balance amount)
(begin (set! balance (- balance amount))
balance)
"Insufficient funds"))
(define (deposit amount)
(set! balance (+ balance amount))
balance)
(let ((protected (make-serializer)))
(define (dispatch m)
(cond ((eq? m ’withdraw) (protected withdraw))
((eq? m ’deposit) (protected deposit))
((eq? m ’balance) balance)
(else (error "Unknown request - MAKE-ACCOUNT"
m))))
dispatch))





"(define (make-account-and-serializer balance)
(define (withdraw amount)
(if (>= balance amount)
(begin (set! balance (- balance amount))
balance)
"Insufficient funds"))
(define (deposit amount)
(set! balance (+ balance amount))
balance)
(let ((balance-serializer (make-serializer)))
(define (dispatch m)
(cond ((eq? m ’withdraw)
(balance-serializer withdraw))
((eq? m ’deposit)
(balance-serializer deposit))
((eq? m ’balance) balance)
((eq? m ’serializer) balance-serializer)
(else (error
"Unknown request - MAKE-ACCOUNT"
m))))
dispatch))  "



(define (deposit account amount)
((account ’deposit) amount))


(define (make-serializer)
(let ((mutex (make-mutex)))
(lambda (p)
(define (serialized-p . args)
(mutex ’acquire)
(let ((val (apply p args)))
(mutex ’release)
val))
serialized-p)))


(define (make-mutex)
(let ((cell (list false)))
(define (the-mutex m)
(cond ((eq? m ’acquire)
(if (test-and-set! cell)
(the-mutex ’acquire))) ; retry
((eq? m ’release) (clear! cell))))
the-mutex))
(define (clear! cell)
(set-car! cell false))


(define (test-and-set! cell)
(if (car cell)
true
(begin (set-car! cell true)
false)))



(define (test-and-set! cell)
(without-interrupts
(lambda ()
(if (car cell)
true
(begin (set-car! cell true)
false)))))
