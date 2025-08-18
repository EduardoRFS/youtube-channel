# Code as Code

## Another language

```rust
Term (M, N, K) ::=
  | x | x = N; K // var & let
  | 0..9 | M + N // number & add

n + m |-> n{+ m} // add
x = N; K |-> K{x := N} // subst
```

## Rewriting

```rust
// example
x = 1 + 2; x + x + x

// can go to, 3
x = 3; x + x + x // add
3 + 3 + 3 // subst
6 + 3 // add
9

// or, 5
(1 + 2) + (1 + 2) + (1 + 2) // subst
3 + (1 + 2) + (1 + 2) // add
3 + 3 + (1 + 2) // add
3 + 3 + 3 // add
6 + 3 // add
9
```

## Lambda Calculus + Let

```rust
Term (M, N, K) ::=
  | x | x = N; K // var & let
  | (x) => K | M(N) // lambda & apply
  | 0..9 | M + N // number & add

Env Context (L) ::=
  | _ | x = N; L

n + m |-> n{+ m} // add
x = N; K |-> K{x := N} // subst
L[(x) => K](N) |-> L[x = N; K] // beta at a distance

// at a distance because
(((x) => (y) => K)(M))(N)
(x = M; (y) => K)(N) // beta
x = M; y = N; K // beta at a distance

// because
L == (x = M; _)
L[(y) => K](N)
L[y = N; K] // beta at a distance
x = M; y = N; K // plug back
```

## Value Substitution Calculus

```rust
Term (M, N, K) ::=
  | x | x = N; K // var & let
  | (x) => K | M(N) // lambda & apply
  | 0..9 | M + N // number & add

Env Context (L) ::=
  | _ | x = N; L

Value (V) ::=
  | 0..9 | x | (x) => K

n + m |-> n{+ m} // add
x = L[V]; K |-> L[K{x := V}] // value subst
L[(x) => K](N) |-> L[x = N; K] // beta at a distance

// can not do subst here
x = 1 + 2; x + x + x
// aka it cannot go to

x = 1 + 2; y = 3 + 4; x + y
x = 3; y = 3 + 4; x + y
x = 3; y = 7; x + y
// or
x = 1 + 2; y = 7; x + y
x = 3; y = 7; x + y
```

## Linear Substitution Calculus

```rust
Term (M, N, K) ::=
  | x | x = N; K // var & let
  | (x) => K | M(N) // lambda & apply
  | 0..9 | M + N // number & add

Context (C) ::=
  | _ // hole
  | x = C; K | x = N; C
  | (x) => C | C(N) | M(C)
  | C + N | M + C

Env Context (L) ::=
  | _ | x = N; L

n + m |-> n{+ m} // add
x = M; C[x] |-> x = M; C[M] // linear subst
x = M; K |-> K  (x ∉ fv(K)) // garbage collection
L[(x) => K](N) |-> L[x = N; K] // beta at a distance

// example of context in the middle
x = 1; y = x; y
// same as
x = 1; C[x]  (C == (y = _; y))
x = 1; C[1]  (C == (y = _; y)) // ls
x = 1; y = 1; y

// so
x = 1; y = x; y
x = 1; y = 1; y // ls

// example
x = 1 + 2; y = x; x + x
x = 3; y = x; x + x // add
x = 3; y = x; 3 + x // ls
x = 3; y = x; 3 + 3 // ls
x = 3; y = x; 6 // add
x = 3; y = x; 6 // gc
x = 3; 6 // gc
6
```
