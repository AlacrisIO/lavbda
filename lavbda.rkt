#lang at-exp racket @; -*- Scheme -*-
#|
Alacris: Language Abstraction for [V]erifiable Blockchain Decentralized Applications
IOHK Summit, April 18th 2019

To compile it, use:
   racket lavbda.rkt > lavbda.html

This document is available under the bugroff license.
   http://tunes.org/legalese/bugroff.html

Abstract Abstract: Alacris chief architect François-René Rideau discusses the operating system's
domain specific language for developing decentralized apps that can be automatically verified to
protect their assets against known attack techniques, and used to specify multi-party protocols
to be run on clients and servers as well as smart contracts.

Abstract: It is extremely hard to build non-trivial Blockchain Decentralized Applications (DApps)
that can hope to remain secure when protecting large assets against dedicated attackers.
The Alacris Operating System is growing a Domain Specific Language (DSL) to enable development
of DApps that can be automatically formally verified to run correctly even when faced with
adversarial behavior. More than libraries on a general purpose language, the DSL can enforce
global program invariants. More than a smart contract language, the DSL specifies a multiparty
protocol, from which all code can be extracted, correctly, that will run on clients and servers
as well as in blockchain smart contracts. The DApp compilation strategies can be ported to all
blockchains and will address interoperability, scalability and privacy.
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

(define (xth . x) (apply th fgcolor: *green* bgcolor: *light-blue* x))
(define (xtd . x) (apply td fgcolor: *green* bgcolor: *light-red* x))
(define (td+ . x) (apply td fgcolor: *green* bgcolor: *light-green* x))
(define (td- . x) (apply td fgcolor: *green* bgcolor: *light-red* x))
(define (td= . x) (apply td fgcolor: *green* bgcolor: *light-blue* x))

(define (tC (x '())) (td style: "text-align: center; border: none;" x))
(define (tL (x '())) (td style: "text-align: left; border: none;" x))
(define (tR (x '())) (td style: "text-align: right; border: none;" x))


(define (d (repetitions 1)) (make-string repetitions #\u202F)) ; U+202F NARROW NO-BREAK SPACE > <

(slide ()
  @table[(tr(td width: "33%")(td (div fgcolor: *red*
  @b{@(d 4)𝕃@(d)anguage @(br)
     @(d 4)𝔸@(d)bstraction for @(br)
          ⟦𝕍⟧@(d)erifiable @(br)
     @(d 4)𝔹@(d 2)lockchain @(br)
     @(d 4)𝔻@(d 2)ecentralized @(br)
     @(d 4)𝔸@(d)pplications}))(td width: "33%"))]
  ~
  @p{François-René Rideau, @em{Alacris}}
  @C{fare@"@"alacris.io}
  ~
  @p{IOHK Summit, 2019-04-11}
  @url{https://alacris.io/}) ;; lavbda.alacris.io

(slide-group "Introduction: Challenges for Secure DApps"
(gslide () @h1{Why No DApps? a Vicious Circle}
 ~
 (let-values (((x y z t) (values "No apps" "No users" "No money" "No tech")))
   (table class: "noborder" id: "noborder"
    (tr (tC)     (tC x) (tC))
    (tr (tR "⬈") (tC)   (tL "⬊"))
    (tr (tC t)   (tC)   (tC y))
    (tr (tR "⬉") (tC)   (tL "⬋"))
    (tr (tC)     (tC z) (tC))))
 ~
 @fragment{Typical bootstrapping issue!})

(gslide () @h1{What Missing Tech?}
 ~
 @p{Scalability}
 @p{Interoperability}
 @p{Portability}
 @p{Usability}
 ~
 @fragment{@h6{Security}}
 @comment{})

(gslide () @h1{Why is Blockchain Security so Hard?}
 @L{Transactions: high-stake, irreversible.}
 @p{The "bug budget" is @em{zero}.}
 @comment{Aerospace or biomedical industries}
 ~
 @L{Code is fragile.}
 @p{Usual languages, tools & methodologies @em{don't even try}.}
 @comment{Parity Wallet: 400 lines, one bug, 280 M$ disappeared!}
 ~
 @L{The Internet is hostile.}
 @p{Each dollar controlled by a DApp is @em{a bounty to the bad guys}.})

(gslide () @h1{The Solution: Logic}
 @L{Dijkstra's approach: use math, prove everything correct.}
 @L{@em{You} may eschew math automation—the bad guys won't.}
 ~
 @L{You can't retrofit math in existing code.}
 @L{You must build around math from the start.}
 ~
 @L{Complexity quickly makes math intractable.}
 @L{Adopt Radical Simplicity—in math terms.})

(gslide () @h1{Alacris: Our Take Home Points}
 ~
 @L{Building secure DApps is extremely hard,}
 @L{a DSL makes it tractable.}
 ~
 @L{Automatic Cascading Verification of correctness,}
 @L{from DSL down to bit-bashing, composing full abstractions.}
 ~
 @L{Blockchain-Agnostic Model: Consensus-as-Court}
 @L{Portab-, Interoperab-, Scalab- ility—through @em{Logic}.}))

(slide-group "A Domain Specific Language (DSL) for DApps"
(gslide () @h1{Why not just a Library?}
 @L{A Library: can @em{do} everything, but not @em{prevent} much.}
 @L{Manually respect its unenforced global invariants… or else.}
 @L{Leaks complexity, makes verification harder.}
 ~
 @L{A DSL: can express both positive and negative.} ;; XXXX link to full abstraction
 @L{Global invariants automatically enforced.}
 @L{Seals complexity. Makes verification easier.})

(gslide () @h1{Why not just a new General Purpose Language?}
 @L{General Purpose Language: Library-generator.}
 @L{Leaks complexity exponentially until untractable.}
 @L{Problem: mushed many levels of abstraction into one.}
 ~
 @L{Proper DSLs: keep small problem spaces.}
 @L{Seal complexity at each level of abstraction.}
 @L{General-Purpose Logic Meta-Language: factor in multiple layers.})

(gslide () @h1{Why not just a Contract Language?}
 @L{A DApp is much more than a smart contract:}
 @L{Also code running on clients, servers, etc.}
 @L{Any bug and poof money gone. Any discrepancy is a bug.}
 ~
 @L{DSL: a single spec for the entire DApp.}
 @L{End-Point Projection: Extract all code for each and every component.}
 @L{Do it correctly. Do it consistently across components.})

(gslide () @h1{Why not a least share VM with Contracts?}
 @L{Contract VM is for deterministic consensual computations.}
 @L{Computations cost > 10⁶ more than for cloud computing.} ;; over a million times
 @L{Optimize programs for cost-conscious execution.}
 ~
 @L{DApp VM is for asynchronous multiparty computations.}
 @L{Most computations are on private cloud computers.}
 @L{Optimize programs for Auditability of Correctness.}

 @comment{XXXX Cut...
   Consensus: everything computed is public
   All: Keys are private information
   Poker: hands are private information
 })

(gslide () @h1{What features in the DApp DSL then?}
 @L{Functional Programming.}
 @L{Asynchronous Communication.}
 @L{Cryptographic Primitives.}
 @L{Modal Logic: Epistemic + Temporal.}
 @L{Linear Logic: Resource Management.}
 @L{Game Theory: Economic Equilibrium.}
 @L{Refinement Logic: Work at many abstraction levels.}
 @L{Extension: Finitary Fragment for zk-SNARKs.}))

(slide-group "Automatic Cascading Verification"
(gslide () @h1{Semantic Tower}
  @L{Verify entire semantic tower, from user spec to bit bashing.}
  @L{Address each issue at proper level of abstraction.}
  ~
  @L{Zoom in and out, at runtime.}
  @L{Full Abstraction: no semantic leak.} ;; XXXXXX
  ~
  @L{Average user get automatic theorem proofs with Z3.}
  @L{System extenders prove extensions correct in Coq.})

(gslide () @h1{Correctness Properties to Automatically Verify}
@L{User-defined protocol invariants.}
~
@L{Linear Resources, Access Control, Time Bounds.}
~
@L{Game-Theoretic Liveness: progress if all actors honest.}
~
@L{Game-Theoretic Safety: no loss to bad actors.})

(gslide () @h1{Verification techniques}
  @L{Type Theory: manual with Coq for system extenders.}
  @L{Theorem Proving: automated with Z3 for users.}
  @L{Model Checking: domain-specific models.}
  @L{Strand Spaces: model attacker capabilities.}
  @L{Dynamical System Simulation: test attack scenarios.}
  @L{Composable Implementation Layers: keep complexity in check.})

(gslide () @h1{Composable implementation layers}
  @L{Category Theory: Computations as categories.}
  @L{States as nodes ("objects"), transitions as arrows ("morphisms").}
  @L{Implementations as partial functors (profunctors).}
  @L{Game-Theoretic Safety & Liveness as composable properties.}
  @L{Code Instrumentations as natural transformations.}
  ~
  @L{Good sign: functoriality implies full abstraction!})

(gslide () @h1{Less Formal Methods}
  @L{Lightweight Formal methods: Quickly check simple properties.}
  @L{Starve attackers of low-hanging fruits.}
  ~
  @L{Can't do without axioms. Can make them explicit, audit them.}
  @L{Automatically keep track of axioms at every level of abstraction.}
  ~
  @L{Human Processes matter.}
  @L{Design. Review. Discipline. Check lists. Red team.}))

(slide-group "Blockchain-Agnostic Model: Consensus-as-Court"
(gslide () @h1{Consensus-as-Court}
  @L{Analogy: common abstraction, different parameters}
  ~
  @L{Conflict avoidance and resolution system.}
  @L{Avoidance: Fast. Good guy pays all the time.}
  @L{Resolution: Slow. Bad guy pays in unhappy case.}
  ~
  @L{Machines: verification games with fast cheap rigid logic.}
  @L{Humans: legal arguments with slow scarce flexible rhetoric.})

(gslide () @h1{Logic for Smart Contracts}
  @L{Arbitrary logical formula for smart contract clause.}
  @L{NB: Requires a logic model for blockchains or side-chains.}
  ~
  @L{@em{Game Semantics}: translate formulas to verification games.}
  @L{@em{Fundamental Theorem}: Good guy has winning strategy.}
  ~
  @L{Bad guy loses, then pays damages and court fees.}
  @L{With any challengeable claim, deposit collateral as bond.})

(gslide () @h1{Mutual Knowledge}
  @L{Winning Strategy: Not just "there exists" but "I know"}
  ~
  @L{All evidence must be Mutual Knowledge (MK).}
  ~
  @L{Scale with general purpose MK validator network.})

(gslide () @h1{Extension: Zero-Knowledge Proofs}
  @L{Interactive but private validation.}
  @L{Anyone can see who's right, about what stays private.}
  ~
  @L{Non-interactive a priori validation.}
  @L{Trade-off: good guy pays all the time, a lot.}
  ~
  @L{Interoperability: commitment with different hash functions}
  @L{Gambling: Homomorphic encryption of card game hands})

(gslide () @h1{DSL: Abstract over Backend}
  @L{This blockchain vs That blockchain}
  @L{Non-Interactive enforcement vs Interactive verification}
  @L{Public computation vs Private computation}
  @L{Slow and trustless vs Fast with semi-trusted middleman}
  ~
  @p{Different sets of users have different needs for backends. @(br)
     Different blockchains offer different capabilities to backends.}
  @comment{No One-size-fits-all backend. Yes One-size-fits-all DApp.})

(gslide () @h1{Blockchain-Agnostic Model}
  @L{Portability}
  @L{Interoperability}
  @L{Scalability}
  @L{Usability}
  @L{@b{Security}}
  ~
  @L{Mathematical essence of the Blockchain}))

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

(gslide () @h1{The Meta-Story}
 @L{Go to the mathematical essence of things.}
 @L{Itself the essence of category theory.}
 @L{Identify what the domain is and isn't.}
 ~
 @L{Strip all incidental complexity.}
 @L{Embrace multiple levels of abstraction.}
 @L{Reconcile Semantics and Reflection.}
 @comment{
   In the words of Dick Gabriel:
   The programming language paradigm vs the systems paradigm.
 }
 ;; ~ @p[class: 'fragment]{Any question?}
 )

(gslide () @h1{Contact}
 ~
 @L{I NEED MORE INFO!   Our website @url{https://alacris.io/}}
 ~
 @L{I WANT TO FOLLOW ALONG!   Medium @url{https://medium.com/alacris}}
 ~
 @L{I WANT TO HELP!   Telegram @url{https://t.me/alacrisio}}
 ~
 @L{SHOW ME THE CODE!   @url{https://github.com/AlacrisIO}}))

(reveal)
