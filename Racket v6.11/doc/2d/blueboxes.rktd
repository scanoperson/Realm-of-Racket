736
((3) 0 () 2 ((q lib "2d/dir-chars.rkt") (q lib "2d/readtable.rkt")) () (h ! (equal) ((c def c (c (? . 0) q dn-chars)) q (3875 . 2)) ((c def c (c (? . 0) q rt-chars)) q (3945 . 2)) ((c def c (c (? . 0) q up-chars)) q (3840 . 2)) ((q form ((lib "2d/cond.rkt") 2dcond)) q (0 . 33)) ((c def c (c (? . 0) q double-barred-chars)) q (3794 . 2)) ((q form ((lib "2d/tabular.rkt") 2dtabular)) q (1961 . 26)) ((q form ((lib "2d/match.rkt") 2dmatch)) q (1127 . 22)) ((c def c (c (? . 1) q 2d-readtable-dispatch-proc)) q (2944 . 17)) ((c def c (c (? . 0) q adjustable-chars)) q (3751 . 2)) ((c def c (c (? . 0) q lt-chars)) q (3910 . 2)) ((c def c (c (? . 1) q make-readtable)) q (2901 . 2)) ((q def ((lib "2d/lexer.rkt") 2d-lexer)) q (3692 . 3))))
syntax
(2dcond cond-content)
 
 cond-content = question-row
                body-row
                ⋮
              | question-row
                body-row
                ⋮
                else-row
                 
 question-row = empty-cell question-cell ⋯
              | empty-cell question-cell ⋯ else-cell
                 
     body-row = question-cell exprs-cell ⋯
                 
     else-row = question-cell exprs-cell ⋯ else-cell
                 
question-cell = ╔═════════════╗
                ║question-expr║
                ╚═════════════╝
                 
   empty-cell = ╔═══╗
                ║   ║
                ╚═══╝
                 
   exprs-cell = ╔═════════════╗
                ║expr expr ...║
                ╚═════════════╝
                 
    else-cell = ╔══════╗
                ║ else ║
                ╚══════╝
syntax
(2dmatch match-content)
 
  match-content = match-first-row
                  match-row
                  ⋮
                   
match-first-row = two-expr-cell match-pat-cell ⋯
                   
      match-row = match-pat-cell exprs-cell ⋯
                   
  two-expr-cell = ╔═════════════════╗
                  ║col-expr row-expr║
                  ╚═════════════════╝
                   
 match-pat-cell = ╔═════╗
                  ║ pat ║
                  ╚═════╝
                   
     exprs-cell = ╔═════════════╗
                  ║expr expr ...║
                  ╚═════════════╝
syntax
(2dtabular tabular-content)
 
tabular-content = tabular-row
                  ⋮
                | tabular-row
                  ⋮
                  style-cell
                   
    tabular-row = tabular-cell ⋯
                   
   tabular-cell = ╔════════════════╗
                  ║tabular-expr ...║
                  ╚════════════════╝
                   
     style-cell = ╔═════════════════╗
                  ║style-content ...║
                  ╚═════════════════╝
                   
  style-content = #:style style-expr
                | #:sep sep-expr
                | #:ignore-first-row
 
  style-expr : style?
  sep-expr : (or/c block? content? #f)
  tabular-expr : (or/c block? content?)
procedure
(make-readtable) -> readtable?
procedure
(2d-readtable-dispatch-proc char           
                            port           
                            source         
                            line           
                            column         
                            position       
                            /recursive     
                            readtable) -> any/c
  char : char?
  port : input-port?
  source : any/c
  line : (or/c exact-positive-integer? #f)
  column : (or/c exact-nonnegative-integer? #f)
  position : (or/c exact-positive-integer? #f)
  /recursive : (-> input-port? any/c (or/c readtable? #f) any/c)
  readtable : (or/c #f readtable?)
procedure
(2d-lexer sub) -> lexer/c
  sub : lexer/c
value
adjustable-chars : (listof char?)
value
double-barred-chars : (listof char?)
value
up-chars : (listof char?)
value
dn-chars : (listof char?)
value
lt-chars : (listof char?)
value
rt-chars : (listof char?)
