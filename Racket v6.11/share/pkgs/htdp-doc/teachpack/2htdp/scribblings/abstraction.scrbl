#lang scribble/doc

@(require "shared.rkt" scribble/manual scribble/eval
          (for-label
	    teachpack/2htdp/abstraction
	    (only-in lang/htdp-beginner require check-expect explode implode)
	    (except-in racket 
              require match
	      for/list for/or for/and for/sum for/product 
	      for*/list for*/or for*/and for*/sum for*/product
	      in-range in-naturals
	      )
	    ))	

@; ---------------------------------------------------------------------------------------------------

@teachpack["abstraction"]{Abstraction}

@author{Matthias Felleisen}

@defmodule[#:require-form beginner-require 2htdp/abstraction #:use-sources (teachpack/2htdp/abstraction)]

The @tt{abstract.rkt} teachpack provides some additional abstraction
facilities: comprehensions and loops, matching, and algebraic data types.
Most of these are restricted versions of full-featured constructs in other
members of the Racket family so that students of HtDP/2e don't stumble
across syntactic oddities.

HtDP/2e introduces loops and matching in an intermezzo, with the sole
purpose of acknowledging the existence of powerful linguistic mechanisms.

Algebraic data types are provided for those who think teaching the features
of functional programming is more important than teaching universally
applicable ideas of program design.

@history[#:added "1.1"]

@;-----------------------------------------------------------------------------
@section[#:tag "abstraction" #:tag-prefix "x"]{Loops and Comprehensions}

@defform/subs[#:id for/list
              (for/list (comprehension-clause comprehension-clause ...) body-expr)
              ([comprehension-clause (name clause-expr)])]{
 evaluates @racket[body-expr] for the @bold{parallel} sequences of values
 determined by the @racket[comprehension-clause]s. 

 Each @racket[comprehension-clause] binds its @racket[name] in
 @racket[body-expr]. 

 The @racket[for/list] expression evaluates all @racket[clause-expr] to
 generate sequences of values. If a @racket[clause-expr] evaluates to a
@itemlist[
 @item{list, its items make up the sequence values;}
 @item{natural number @racket[n], the sequence of values consists of the
 numbers @racket[0], @racket[1], ..., @racket[(- n 1)];}
 @item{string, its one-character strings are the sequence items.}
]
 For sequences generated by @racket[in-range] and @racket[in-naturals], see below.

 Finally, @racket[for/list] evaluates  @racket[body-expr] with
 @racket[name] ... successively bound to the values of the sequences
 determined by @racket[clause-expr] ...
@interaction[#:eval (make-base-eval '(require 2htdp/abstraction))
(for/list ((i 10))
  i)

(for/list ((i 2) (j '(a b)))
  (list i j))

(for/list ((c "abc"))
  c)
]

 The evaluation stops when the shortest sequence is exhausted.
@interaction[
(for/list ((i 2) (j '(a b c d e)))
  (list i j))
]
}

@defform[#:id for*/list 
         (for*/list (comprehension-clause comprehension-clause ...) body-expr)]{
 evaluates @racket[body-expr] for the @bold{nested} sequences of values
 determined by the @racket[comprehension-clause]s. 

 Each @racket[comprehension-clause] binds its @racket[name] in the
 expressions of the following @racket[comprehension-clause]s as well as 
 @racket[body-expr]. 

@interaction[
(for*/list ((i 2) (j '(a b)))
  (list i j))

(for*/list ((i 5) (j i))
  (list i j))
]

 With nesting, the evaluation does @bold{not} stop when the shortest sequence
 is exhausted because @racket[comprehension-clause]s are evaluated in order: 
@interaction[
(for*/list ((i 2) (j '(a b c d e)))
  (list i j))
]
}

@defform[(for/or (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for/list]. It produces the first non-@racket[#false] value, if
 any, and @racket[#false] otherwise. 

@interaction[#:eval (make-base-eval '(require 2htdp/abstraction))
(for/or ([c "abcd"])
   (if (string=? "x" c) c #false))

(for/or ([c (list #false 1 #false 2)])
   c)
]
}

@defform[(for*/or (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for*/list]. It produces the first non-@racket[#false] value, if
 any, and @racket[#false] otherwise. 

@interaction[
(for*/or ([i 2][j i])
   (if (> j i) (list i j) #false))
]
}

@defform[(for/and (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for/list]. If any evaluation of @racket[body-expr] produces
 @racket[#false], the loop stops and returns @racket[#false], too; otherwise,
 the loop produces the result of the last evaluation of @racket[body-expr]. 

@interaction[
(for/and ([c '(1 2 3)])
   (if (> c 4) c #false))

(for/and ([c '(1 2 3)])
   (if (< c 4) c #false))
]
}

@defform[(for*/and (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for*/list]. If any evaluation of @racket[body-expr] produces
 @racket[#false], the loop stops and returns @racket[#false], too; otherwise,
 the loop produces the result of the last evaluation of @racket[body-expr]. 

@interaction[
(for*/and ([i 2][j i])
   (if (< j i) (list i j) #false))
]
}

@defform[(for/sum (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for/list]. It adds up the numbers that @racket[body-expr]
 evaluates to. 

@interaction[
(for/sum ([i 2][j 8])
   (max i j))
]
}

@defform[(for*/sum (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for*/list]. It adds up the numbers that @racket[body-expr]
 evaluates to. 

@interaction[
(for*/sum ([i 2][j i])
   (min i j))
]
}

@defform[(for/product (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for/list]. It multiplies the numbers that @racket[body-expr]
 evaluates to. 

@interaction[
(for/product ([i 2][j 3])
   (+ i j 1))
]
}

@defform[(for*/product (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for*/list]. It multiplies the numbers that @racket[body-expr]
 evaluates to. 

@interaction[
(for*/product ([i 2][j i])
   (+ i j 1))
]
}

@defform[(for/string (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for/list]. It collects the one-character strings that
 @racket[body-expr] evaluates to with @racket[implode]. 

@interaction[
#:eval 
(make-base-eval 
  '(require 2htdp/abstraction 
            (only-in lang/htdp-beginner string->int int->string)))
(for/string ([i "abc"])
   (int->string (+ (string->int i) 1)))
]
}

@defform[(for*/string (comprehension-clause comprehension-clause ...) body-expr)]{
 iterates over the sequences generated by the @racket[comprehension-clause]s
 like @racket[for/list]. It collects the one-character strings that
 @racket[body-expr] evaluates to with @racket[implode]. 

@interaction[
#:eval 
(make-base-eval 
  '(require 2htdp/abstraction 
            (only-in lang/htdp-beginner string->int int->string)))
(for*/string ([i "ab"][j (- (string->int i) 90)])
   (int->string (+ (string->int i) j)))
]
}

@; -------------------------------------------------------
@defproc*[([(in-range [start natural-number/c] 
		      [end natural-number/c]
		      [step natural-number/c]) 
              sequence?]
	   [(in-range [end natural-number/c]) 
	      sequence?])]{
 generates a @bold{finite} sequence of natural numbers.

 If @racket[start], @racket[end], and @racket[step] are provided, the
 sequence consists of @racket[start], @racket[(+ start step)], @racket[(+
 start step step)], ...  until the sum is greater than or equal to
 @racket[end].  

@interaction[ 
(for/list ([i (in-range 1 10 3)]) i)
]

 If only @racket[end] is provided, @racket[start] defaults to @racket[0]
 and @racket[step] to @racket[1]: 
@interaction[
(for/list ([i (in-range 3)])
  i)

(for/list ([i (in-range 0 3 1)])
  i)
]
 }

@defproc[(in-naturals [start natural-number/c]) sequence?]{
  generates an @bold{infinite} sequence of natural numbers, starting with
  @racket[start].

@interaction[
#:eval
(make-base-eval)
(define (enumerate a-list)
  (for/list ([x a-list][i (in-naturals 1)])
    (list i x)))

(enumerate '(Maxwell Einstein Planck Heisenberg Feynman))
(enumerate '("Pinot noir" "Pinot gris" "Pinot blanc"))
]
}

@;-----------------------------------------------------------------------------
@section[#:tag "matching" #:tag-prefix "x"]{Pattern Matching}

@defform/subs[#:id match
              (match case-expr (pattern body-expr) ...)
              ([pattern 
                 name 
	         literal-constant
                 (cons pattern pattern)
                 (name pattern ...)
                 (? name)])]{
 dispatches like a @racket[cond], matching the result of @racket[case-expr]
 sequentially against all @racket[pattern]s. The first successful match
 triggers the evaluation of the matching @racket[body-expr], whose value is the
 result of the entire @racket[match] expression.

 The literal constants commonly used are numbers, strings, symbols, and
 @racket['()]. 

 Each pattern that contains @racket[name]s binds these names in the
 corresponding @racket[body-expr]. 

 Matching a value with a pattern proceeds according to the following rules. 
 If the pattern is a
@itemlist[
@item{@racket[name], it matches any value;}
@item{@racket[literal-constant], it matches only the literal constant;}
@item{@racket[(cons pattern_1 pattern_2)], it matches when the value is an
 instance of @racket[cons], and its first/rest fields match @racket[pattern_1] 
 and @racket[pattern_2], respectively;}
@item{@racket[(name pattern ...)], it matches when the value is an instance of
 the @racket[name] structure type, and its field values match @racket[pattern]
 ...;} 
@item{@racket[(? name)], it matches when @racket[name] refers to a predicate
 function and the latter produces @racket[#true] on the given value.}
]
 Furthermore, if the given pattern is @racket[name] and the value is
 @racket[V], @racket[name] stands for @racket[V] during the evaluation of the
 corresponding @racket[body-expr]. 
 
The following @racket[match] expression distinguishes @racket[cons]es with
@racket['()] in the second position from all others: 
@interaction[#:eval (make-base-eval '(require 2htdp/abstraction))
(define (last-item l)
   (match l 
     [(cons lst '()) lst]
     [(cons fst rst) (last-item rst)]))

(last-item '(a b c))
]

With ?, a @racket[match] can use a predicate to distinguish arbitrary values: 
@interaction[#:eval (make-base-eval '(require 2htdp/abstraction))
(define (is-it-odd-or-even l)
   (match l 
     [(? even?) 'even]
     [(? odd?)  'odd]))

(is-it-odd-or-even '1)
(is-it-odd-or-even '2)
]

A @racket[match] expression can also deal with structure instances: 
@interaction[#:eval (make-base-eval '(require 2htdp/abstraction))
(define-struct doll (layer))

(define (inside a-doll)
  (match a-doll 
    [(? symbol?) a-doll]
    [(doll below) (inside below)]))

(inside (make-doll (make-doll 'wood)))
]
Note, however, that the pattern uses just @racket[doll], the name of the
structure type, not @racket[make-doll], the constructor name. 
}


@;-----------------------------------------------------------------------------
@section[#:tag "adt" #:tag-prefix "x"]{Algebraic Data Types}

@defform/subs[#:id define-type
              (define-type type (variant (field predicate) ...) ...)
              ([type name]
	       [variant name]
	       [field name]
	       [predicate name])]{
 defines structure types @racket[variant] ... with fields
 @racket[field] ..., respectively. In addition, it defines constructors
 that enforce that the field values satisfy the specified predicate. Finally,
 it introduce the name @racket[type] as the name for the union of all
 @racket[variant] structure types and @racket[type?] as a predicate
 that determines whether a value belongs to this class of values. 

Consider the following type definition: 
@;%
@(begin
#reader scribble/comment-reader
(racketblock
(define-type BTree
  (leaf (info number?))
  (node (left BTree?) (right BTree?)))
))
@;%
 It defines two structure types: 
@;%
@(begin
#reader scribble/comment-reader
(racketblock
(define-struct leaf (info))
(define-struct node (left right))
))
@;%
 The @racket[make-leaf] constructor signals an error when applied to any other
 values but numbers, while @racket[make-node] accepts only instances of
 @racket[BTree]. Finally, @racket[BTree?] is a predicate that recognizes such
 instances: 
@interaction[#:eval (make-base-eval '(require 2htdp/abstraction) '(define-type BTree (leaf (info number?)) (node (left BTree?) (right BTree?))))
(make-leaf 42)
(make-node (make-leaf 42) (make-leaf 21))
(BTree? (make-node (make-leaf 42) (make-leaf 21)))
]
And here is how a constructor fails when applied to the wrong kind of values: 
@interaction[#:eval (make-base-eval '(require 2htdp/abstraction) '(define-type BTree (leaf (info number?)) (node (left BTree?) (right BTree?))))
(make-leaf 'four)
]
}

@defform[#:id type-case
         (type-case type case-expr (variant (field ...) body-expr) ...)]{
 dispatches like a @racket[cond], matching the result of @racket[case-expr] sequentially
 against all @racket[variant]s. The first successful match triggers the
 evaluation of the matching @racket[body-expr], whose value is the result of
 the entire @racket[type-case] expression. 

 A @racket[type-case] expression also ensures that (1) the collection
 @racket[variant] cases covers all variant structure type definitions in
 @racket[type] and (2) that each @racket[variant] clauses specifies as many fields as
 the definition of @racket[type] specifies. 

Assume that the following definition is placed in the scope of the above type
definition for @racket[BTree]:
@;%
@(begin
#reader scribble/comment-reader
(racketblock
(define (depth t)
  (type-case BTree t
    [leaf (info) 0]
    [node (left right) (+ (max (depth left) (depth right)) 1)]))
))
@;%
 This function definition uses a @racket[type-case] for @racket[BTree] and the
 latter consists of two clauses: one for @racket[leaf]s and one for
 @racket[node]s. The function computes the depth of the given tree. 

@interaction[#:eval 
(make-base-eval 
 '(require 2htdp/abstraction) 
 '(define-type BTree (leaf (info number?)) (node (left BTree?) (right BTree?)))
 '(define (depth t)
    (type-case BTree t
      [leaf (info) 0]
      [node (left right) (+ (max (depth left) (depth right)) 1)])))

(depth (make-leaf 42))
(depth (make-node (make-leaf 42) (make-leaf 21)))
]
}
