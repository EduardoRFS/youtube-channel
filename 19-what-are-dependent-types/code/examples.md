```rust
-------------
(Type : Type)

A : Type      B : Type
---------------------------
((x : A) -> B : Type)

A : Type    M : B
-------------------------
(((x : A) => M) : ((x : A) -> B));

M : (x : A) -> B   N : A
-------------------------------
(M N : B[x := N])

(x : Int) => x
(A : Type) => (x : A) => x
(A : Type) => A
(b : Bool) => b Type Int String


(x === m; n) === n[x := m]

Bool === (A : Type) -> (then : A) -> (else : A) -> A;
true : Bool === (A : Type) => (then : A) => (else : A) => then;
false : Bool === A => then => else => else;

f : (pred : Bool) -> (x : pred Type Int String) -> pred Type Int String
  = (pred : Bool) => (x : pred Type Int String) => x;

a : (x : Int) -> Int === f true;
b : (x : String) -> String === f false;


g : (x : Bool) -> Bool === (x : Bool) => x;

Equal (A : Type) (x : A) (y : A) === (P : A -> Type) -> P x -> P y;
refl (A : Type) (x : A) : Equal A x x ===
  (P : A -> Type) => (p : P x) => p;



_ : Equal Bool true true = refl Bool true;
_ : Equal Bool false false = refl Bool false;

not === (b : Bool) => b Bool false true;

not_true_eq_false : Equal Bool (not true) false === refl Bool false;
_ : Equal Bool (not false) true === refl Bool true;

f = (M : Bool -> Type) => (x : M (not true)) : M false =>
  (not_true_eq_false : (P : Bool -> Type) -> P (not true) -> P false)
    (b => M b) x;
```
