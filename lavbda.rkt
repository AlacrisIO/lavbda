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


(define (~ (repetitions 1)) (make-string repetitions #\u202F)) ; U+202F NARROW NO-BREAK SPACE > <
(define (~~) (~ 10))
(define (L~ . x) (apply L (~~) x))

(slide ()
       @table[(tr(td width: "15%")
                 (td width: "33%"
                     (img src: "resources/pic/alacris_logo.png"
                          style: "border: 0; vertical-align: top; background-color: transparent"))
                 (td width: "15%")
                 (td (div fgcolor: *red*
                          @b{@(~ 4)𝕃@(~)anguage @(br)
                             @(~ 4)𝔸@(~)bstraction for @(br)
                             ⟦𝕍⟧@(~)erifiable @(br)
                             @(~ 4)𝔹@(~ 2)lockchain @(br)
                             @(~ 4)𝔻@(~ 2)ecentralized @(br)
                             @(~ 4)𝔸@(~)pplications})))]
  ~
  @p{François-René Rideau, @(~)@em{Alacris}}
  @C{fare@"@"alacris.io}
  ~
  @comment{Alacris Tech Talk 2019-04-11} @p{IOHK Summit, 2019-04-18}
  @url{https://alacrisio.github.io/lavbda/}) ;; lavbda.alacris.io

(slide-group "Introduction: Challenges for Secure DApps"
(gslide () @h1{Why No DApps? @(~ 2)a Vicious Circle}
 ~
 (let-values (((x y z t) (values "No apps" "No users" "No money" "No tech")))
   (table class: "noborder" id: "noborder"
    (tr (tC)     (tC x) (tC))
    (tr (tR "⬈") (tC)   (tL "⬊"))
    (tr (tC t)   (tC)   (tC y))
    (tr (tR "⬉") (tC)   (tL "⬋"))
    (tr (tC)     (tC z) (tC))))
 ~
 @fragment{@(~)@(br)@(~)@(br) Typical bootstrapping issue!})

(gslide () @h1{What Missing Tech?}
 ~
 @p{Scalability}
 @p{Interoperability}
 @p{Portability}
 @p{Usability}
 @fragment{@h6{Security}}
 @comment{})

(gslide () @h1{Why is Blockchain Security so Hard?}
 @L{1. Transactions: high-stake, irreversible.}
 @fragment[#:index 1]{@L~{The "bug budget" is @em{zero}.}}
 @comment{Aerospace or biomedical industries}
 ~
 @L{2. Code is fragile.}
 @fragment[#:index 2]{@L~{Usual languages, tools & methodologies @em{don't even try}.}}
 @comment{Parity Wallet: 400 lines, one bug, 280 M$ disappeared!}
 ~
 @L{3. The Internet is hostile.}
 @fragment[#:index 3]{@L~{Each dollar controlled by a DApp is @em{a bounty to the bad guys}.}})

(gslide () @h1{The Solution: Logic}
 @L{@em{You} may eschew math automation—the bad guys won't.}
 @fragment[#:index 1]{@L~{Dijkstra's approach: @em{prove all code correct} with math.}}
 ~
 @L{You can't retrofit math in existing code.}
 @fragment[#:index 2]{@L~{You must build around @em{math from the start}.}}
 ~
 @L{Complexity quickly makes math intractable.}
 @fragment[#:index 3]{@L~{Adopt @em{Radical Simplicity}—in math terms.}})

(gslide () @h1{Alacris: Our Take Home Points}
 ~
 @L{1. Building secure DApps is extremely hard,}
 @L~{a Domain Specific Language (DSL) makes it tractable.}
 ~
 @L{2. Automatic Cascading Verification of correctness,}
 @L~{from DSL down to bit-bashing, composing full abstractions.}
 ~
 @L{3. Blockchain-Agnostic Model: Consensus as Court}
 @L~{Scal-, Interoper-, Port-, Us- ability—through @em{Logic}.}))

(slide-group "A Domain Specific Language (DSL) for DApps"
(gslide () @h1{Why not just a Library?}
 @L{A Library: can @em{do} everything, but not @em{prevent} much.}
 @fragment[#:index 1]{
 @L~{Manually respect its unenforced global invariants… or else.}
 @L~{Leaks complexity, makes verification harder.}}
 ~
 @L{A DSL: can express both positive and negative.} ;; XXXX link to full abstraction
 @fragment[#:index 2]{
 @L~{Global invariants automatically enforced.}
 @L~{Seals complexity, makes verification easier.}})

(gslide () @h1{Why not just a new General Purpose Language?}
 @L{General Purpose Language: Library-generator.}
 @fragment[#:index 1]{
 @L~{Leaks complexity exponentially until untractable.}
 @L~{Mushes all abstraction levels into one.}}
 ~
 @L{Proper DSLs: keep small problem spaces.}
 @fragment[#:index 2]{
 @L~{Seal complexity at each level of abstraction.}
 @L~{General-Purpose Logic Meta-Language: factor in multiple layers.}})

(gslide () @h1{Why not just a Contract Language?}
 @L{A DApp is much more than a smart contract:}
 @fragment[#:index 1]{
 @L~{Also code running on clients, servers, etc.}
 @L~{Any bug and poof money gone. Any discrepancy is a bug.}}
 ~
 @L{DSL: a single spec for the entire DApp.}
 @fragment[#:index 2]{
 @L~{End-Point Projection: extract code for all components.}
 @L~{Do it correctly—consistently across components.}})

(gslide () @h1{Why not a least share VM with Contracts?}
 @L{Contract VM is for deterministic consensual computations.}
 @fragment[#:index 1]{
 @L~{Computations cost > 10⁶ more than on cloud.} @comment{over a million times}
 @L~{Optimize programs for cost.}}
 ~
 @L{DApp VM is for asynchronous multiparty computations.}
 @fragment[#:index 2]{
 @L~{Most computations on private cloud.}
 @L~{Optimize programs for auditability.}}

 @comment{XXXX Cut...
   Consensus: everything computed is public
   All: Keys are private information
   Poker: hands are private information
 })

(gslide () @h1{What features in the DApp DSL then?}
 @L{Functional Programming.}
 @L{Asynchronous and Synchronous Communication.}
 @L{Cryptographic Primitives.}
 @L{Modal Logic: Epistemic + Temporal.}
 @L{Linear Logic: Resource Management.}
 @L{Game Theory: Economic Equilibrium.}
 @L{Refinement Logic: Work at many abstraction levels.}
 @L{Finitary Logic: zk-proofs (optional).}))

(slide-group "Automatic Cascading Verification"
(gslide () @h1{Semantic Tower}
  @L{Verify entire semantic tower, from user spec to bit bashing.}
  @fragment[#:index 1]{
  @L~{Full Abstraction: no semantic leak.}} ;; negative constraints
  ~
  @L{Address each issue at proper level of abstraction.}
  @fragment[#:index 2]{
  @L~{Zoom in and out—at runtime.}}
  ~
  @fragment[#:index 3]{
  @L{Regular developers @em{automatically} get proofs with Z3.}
  @L{System extenders @em{manually} prove correctness with Coq.}})

(gslide () @h1{Correctness Properties to Automatically Verify}
  @fragment[#:index 1]{
  @L{User-defined protocol invariants.}}
  ~
  @fragment[#:index 2]{
  @L{Linear Resources, Access Control, Time Bounds.}}
  ~
  @fragment[#:index 3]{
  @L{Game-Theoretic Liveness: progress if all actors honest.}
  @(~)
  @L{Game-Theoretic Safety: no loss to bad actors.}})

(gslide () @h1{Verification techniques}
  @L{@em{Type Theory}: grow system with Coq.}
  @L{@em{Theorem Proving}: user automation with Z3.}
  @L{@em{Model Checking}: domain-specific models.}
  @L{@em{Strand Spaces}: model attacker capabilities.}
  @L{@em{Dynamical System Simulation}: test attack scenarios.}
  @L{@em{Composable Implementation Layers}: keep complexity in check.})

(gslide () @h1{Composable implementation layers}
  @L{Category Theory: Computations as categories.}
  @L~{States as nodes ("objects"), transitions as arrows ("morphisms").}
  ~
  @L{Implementations as partial functors (profunctors).}
  @L~{Game-Theoretic Safety & Liveness as composable properties.}
  @L~{Code Instrumentations as natural transformations.}
  ~
  @fragment[#:index 1]{
  @L{Good sign: functoriality implies full abstraction!}})

(gslide () @h1{Less Formal Methods}
  @L{Lightweight Formal methods: Quickly check simple properties.}
  @fragment[#:index 1]{
  @L~{Starve attackers of low-hanging fruits.}}
  ~
  @L{Can't do without axioms. Can make them explicit, audit them.}
  @fragment[#:index 2]{
  @L~{Automatically track axioms from every abstraction level.}}
  ~
  @L{Human Processes matter.}
  @fragment[#:index 3]{
  @L~{Design. Review. Discipline. Check lists. Red team.}}))

(slide-group "Blockchain-Agnostic Model: Consensus as Court"
(gslide () @h1{Consensus as Court}
  @L{Analogy: common abstraction, different parameters.}
  @L~{Conflict avoidance & resolution. Machines @em{vs} humans.}
  ~
  @L{Avoidance: Good guy pays, all the time. Reliably Slow.}
  @L{Resolution: Bad guy pays, in unhappy case only. Faster/Slower.}
  ~
  @L{Machines: verification games with logic—fast cheap rigid.}
  @L{Humans: legal arguments with rhetoric—slow expensive flexible.})

(gslide () @h1{Logic for Smart Contracts}
  @L{Smart contract clause is @em{arbitrary logical formula}.}
  @L~{NB: Requires logic model of the blockchain or side-chain.}
  ~
  @L{@em{Game Semantics}: translate formulas to verification games.}
  @L{@em{Fundamental Theorem}: Good guy has winning strategy.}
  ~
  @L{Bad guy loses, then pays damages and court fees...}
  @L~{out of @em{bond}—with any claim, deposit collateral.})

(gslide () @h1{Mutual Knowledge}
  @L{Winning Strategy: "there exists" not enough—"I know" needed.}
  @L~{All evidence must be @em{Mutual Knowledge} (MK).}
  ~
  @L{Consensus (@em{Common Knowledge}, CK). State channels. Plasma.}
  @L~{Side-chains? Need a data availability engine, a.k.a. MKB.}
  ~
  @L{Scale with general purpose MK validator network.}
  @L~{MK easier to achieve @em{and shard} than consensus.})

(gslide () @h1{Extension: Zero-Knowledge Proofs}
  @L{@em{Private} interactive validation.}
  @L~{Anyone can see who's right, no one knows about what.}
  ~
  @L{@em{Non-interactive} a priori validation.}
  @L~{Trade-off: good guy pays all the time, a lot.}
  ~
  @L{@em{Interoperability}: commitment with different hash functions.}
  ~
  @L{@em{Gambling}: Homomorphic encryption of card game hands.})

(gslide () @h1{DSL: Abstract over Backend}
  (table class: "noborder" id: "noborder"
    (tr @tR{This blockchain} (tC @em{vs}) @tL{That blockchain})
    (tr @tR{Interactive verification} (tC @em{vs}) @tL{Non-interactive enforcement})
    (tr @tR{Public computation} (tC @em{vs}) @tL{Private computation})
    (tr @tR{Slow and trustless} (tC @em{vs}) @tL{Fast semi-trusted middleman}))
  ~
  @fragment[#:index 1]{
    @L~{Different sets of users have different needs from backends.}
    @L~{Different blockchains offer different capabilities to backends.}}
  ~
  @fragment[#:index 2]{@(~)@(br)@em{One DApp, many backends.}})

(gslide () @h1{Blockchain-Agnostic Model}
  @p{Scalability}
  @p{Interoperability}
  @p{Portability}
  @p{Usability}
  @h6{Security}
  ~
  @fragment{@L{Mathematical essence of the Blockchain:}
            @b{Common Knowledge about Monotonic Verifiable Data Structures}}))

(slide-group "Conclusion"
(gslide () @h1{Alacris: Our Take Home Points (redux)}
 ~
 @L{1. Building secure DApps is extremely hard,}
 @L~{a Domain Specific Language (DSL) makes it tractable.}
 ~
 @L{2. Automatic Cascading Verification of correctness,}
 @L~{from DSL down to bit-bashing, composing full abstractions.}
 ~
 @L{3. Blockchain-Agnostic Model: Consensus as Court}
 @L~{Scal-, Interoper-, Port-, Us- ability—through @em{Logic}.})

(gslide () @h1{The Meta-Story}
 @L{Go to the mathematical essence of things.}
 @L~{Itself the essence of category theory.}
 ~
 @L{Strip all incidental complexity.}
 @L~{Identify what the domain is and isn't.}
 ~
 @L{Embrace multiple levels of abstraction.}
 @L~{Reconcile Semantics and Reflection.}
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

#;(slide-group "Appendix A: Consensus as Court"
(gslide () @h1{}
  @L{Consensus as Court: fruitful analogy.}
  ~
  @L{Specify Contract Clauses with Logic.}
  @L{Validate before... or Verify after (Game Semantics).}
  ~
  @L{Scale any DApp with Mutual Knowledge Base.}
  ~
  @L{zkproofs: privacy, fast validation, interop, gambling…}))


(reveal)

;; Status of the project: closer to the beginning.
;; gap between formal and informal specification.
;; producers and consumers of security are not the same: auditability by third parties.
