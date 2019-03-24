#lang at-exp racket @; -*- Scheme -*-
#|
;; Alacris: Language Abstraction for [V]erifiable Blockchain Distributed Applications
;; IOHK Summit, April 18th 2019
;;

;; To compile it, use:
;;    racket lavbda.rkt > lavbda.html

;; This document is available under the bugroff license.
;;    http://tunes.org/legalese/bugroff.html

;; Abstract Abstract: Alacris chief architect François-René Rideau discusses the operating system's
;; domain specific language for developing distributed apps that can be automatically verified to
;; protect their assets against known attack techniques, and used to specify multi-party protocols
;; to be run on clients and servers as well as smart contracts.

;; Abstract: It is extremely hard to build non-trivial Blockchain Distributed Applications (DApps)
;; that can hope to remain secure when protecting large assets against dedicated attackers.
;; The Alacris Operating System is growing a Domain Specific Language (DSL) to enable development
;; of DApps that can be automatically formally verified to run correctly even when faced with
;; adversarial behavior. More than libraries on a general purpose language, the DSL can enforce
;; global program invariants. More than a smart contract language, the DSL specifies a multiparty
;; protocol, from which all code can be extracted, correctly, that will run on clients and servers
;; as well as in blockchain smart contracts. The DApp compilation strategies can be ported to all
;; blockchains and may address interoperability, scalability and privacy.
|#

(require scribble/html "reveal.rkt")

(define *white* "#ffffff")
(define *gray* "#7f7f7f")
(define *blue* "#0000ff")
(define *light-blue* "#b4b4ff")
(define *red* "#ff0000")
(define *light-red* "#ffb4b4")
(define *green* "#00ff00")
(define *light-green* "#b4ffb4")

(define orig-th th)
(define orig-td td)

(define (xth . x) (apply th fgcolor: *green* bgcolor: *light-blue* x))
(define (xtd . x) (apply td fgcolor: *green* bgcolor: *light-red* x))
(define (td+ . x) (apply td fgcolor: *green* bgcolor: *light-green* x))
(define (td- . x) (apply td fgcolor: *green* bgcolor: *light-red* x))
(define (td= . x) (apply td fgcolor: *green* bgcolor: *light-blue* x))

(define (d (repetitions 1)) (make-string repetitions #\u202F)) ; U+202F NARROW NO-BREAK SPACE > <

(slide ()
  @table[(tr(td width: "33%")(td (div fgcolor: *red*
  @b{@(d 3)@(d)𝕃@(d)anguage @(br)
     @(d 3)@(d)𝔸@(d)bstraction for @(br)
     ⟦𝕍⟧@(d)erifiable @(br)
     @(d 4)𝔹@(d 2)lockchain @(br)
     @(d 4)𝔻@(d 2)istributed @(br)
     @(d 4)𝔸@(d)pplications}))(td width: "33%"))]
  ~
  @p{François-René Rideau, @em{Alacris}}
  @C{fare@"@"alacris.io}
  ~
  @p{IOHK Summit, 2019-04-11}
  @url{https://alacris.io/}) ;; lavbda.alacris.io

(slide-group "Introduction"
(gslide () @h1{Why No DApps? a Vicious Circle}
 ~
 (let-values (((x y z t) (values "No apps" "No users" "No money" "No tech")))
   (let ((td (lambda ((x '())) (td style: "align: center; border: none;" (center x))))
         (tL (lambda ((x '())) (th style: "align: left; border: none;" x)))
         (tR (lambda ((x '())) (th style: "align: right; border: none;" (div align: 'right x)))))
     (table class: "noborder" id: "noborder"
      (tr (td)   #;(td)     (td x) (td)     #;(td))
      (tr #;(td)   (tR "⬈") (td)   (tL "⬊") #;(td))
      (tr (td t) #;(td)     (td)   #;(td)     (td y))
      (tr #;(td)   (tR "⬉") (td)   (tL "⬋") #;(td))
      (tr (td)   #;(td)     (td z) #;(td)     (td)))))
 ~
 @fragment{That's a bootstrapping issue!})

(gslide () @h1{What Missing Tech?}
 ~
 @p{Scalability}
 @p{Portability}
 @p{Interoperability}
 @p{Usability}
 ~
 @fragment{@h3{Security}}
 @comment{})

(gslide () @h1{Why is Security so Hard?}
 @L{Code is fragile.}
 @L{The Internet is hostile.}
 @L{Transactions are irreversible.}
 @comment{Parity Wallet: 400 lines, one bug, 280 M$ disappeared!}
 ~
 @L{The "bug budget" is zero.}
 @L{Usual languages, tools and methodologies don't even try.}
 @L{Solution: EWD's approach—use math, prove everything correct.}
 @comment{
In Blockchain software, your "bug budget" is zero. Common software development languages, tools and methodologies don't even try to reach this level of quality, and fall way short if used.Blockchain is Dijkstra's paradise, where mathematically rigorous correctness is paramount.
Blockchain is Dijkstra's Paradise}))

(slide-group "Conclusion"
(gslide () @h1{The Take Home Points (redux)}
 ~
 @L{Building secure DApps is extremely hard,}
 @L{a DSL makes it tractable.}
 ~
 @L{Automatic Cascading Verification of correctness,}
 @L{from DSL down to bit-bashing, composing full abstractions.}
 ~
 @L{Blockchain-Agnostic Model: Consensus-as-Court}
 @L{brings portability, interoperability, scalability.})

#|
(gslide () @h1{The Meta-Story}
 ~
 @comment{
   When you go to the essence, make it explicit, and strip everything else...
   You've got the approach of Category Theory,
   which is what is good about Functional Programming
 }
 ;; ~ @p[class: 'fragment]{Any question?}
 )
|#

(gslide () @h1{Contact}
 ~
 @L{I NEED MORE INFO!   Medium @url{https://medium.com/alacris}}
 ~
 @L{TAKE MY MONEY!   Our website @url{https://alacris.io/}}
 ~
 @L{I WANT TO HELP!   Telegram @url{https://t.me/alacrisio}}
 ~
 @L{SHOW ME THE CODE!   @url{https://github.com/AlacrisIO}}))


#|

Blockchain Upgrade
changes to the semantic of a blockchain should only take effect after a sufficient delay.
the solution to having long-term contracts that bind two complex evolving blockchains involves
having each chain maintain and publish on itself a complete reflective logical description
of the chain’s logic in its own logic.

Managing Forks

|#

(reveal)

#|

The Alacris Operating System is growing a Domain Specific Language (DSL) to specify Blockchain DApps that can be Formally Verified to be correct.

Why a DSL?
Libraries for existing languages offer more ways to shoot oneself in the foot—verification is harder! A DSL can automatically enforce restrictions and verify program invariants with Z3.

A DApp is much more than a smart contract. From a single DSL specification, we extract all code running on clients and servers as well as smart contracts using End-Point Projection.

A DSL enables Automatic Cascading Verification of the entire semantic tower, with full abstraction, from user specification down to bit bashing. Prove your modular extensions correct in Coq.

A DSL abstracts over multiple backends, offers portability, interoperability across blockchains.


Correctness Properties to Automatically Verify:
User-defined protocol invariants.
Linear Resources, Access Control, Time Bounds.
Game-Theoretic Liveness: progress if all actors honest.
Game-Theoretic Safety: no loss to bad actors.

Verification techniques:
Type theory, theorem proving, model checking, strand spaces, dynamical system simulation, and composable
implementation layers through category theory.

Blockchain-Agnostic Model: Consensus-as-Court
Specify smart contract clauses as logical formulas.
Game Semantics: Good guy has winning strategy.
Bad guy loses, pays damages and fees out of bond.
⚠ All evidence must be Mutual Knowledge (MK).
Scale with general purpose MK validator network.
Option: zkproofs for privacy, non-interactive validation.
|#
