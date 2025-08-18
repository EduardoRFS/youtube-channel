# Data as Code

## The Language

```rust
Term (M, N, K) ::=
  | x | x = N; K // var & let
  | [M, N, ...] | M[0..9+] // arrays & access
  | 0..9 // numbers

// example
x = 0; y = 1; z = [x, y]; z
```

## Simple Linked List

```rust
null = [];
n37 = [37, null];
n99 = [99, n37];
n12 = [12, n99];
n12
```

## Context

```rust
Term (M, N, K) ::=
  | x | x = N; K | [M, N] // pair

Context (C) ::=
  | _ // hole
  | x = C; K | x = N; C
  | [C, N] | [M, C]

// example
C == (x = _; y = z; [x, y])
C[a] == (x = a; y = z; [x, y])
C[b] == (x = b; y = z; [x, y])
```

## The Environment

```rust
Env (E) ::=
  | _ | x = N; E

E == (null = []; _);
E[null] == (null = []; null)

// allow for some tricks like
E == (null = []; n37 = [37, null]; _);
E[null] == (null = []; n37 = [37, null]; null);
E[n37] == (null = []; n37 = [37, null]; n37);

// this
null = []; n37 = [37, null];
// same as
null = []; n37 = [37, null]; _
// or
null = [];
n37 = [37, null];
```

## Shared Linked List

```rust
null = [];
n37 = [37, null];
n99 = [99, n37];
n12 = [12, n99];

// a cons
n25 = [25, n99];
// another one
n17 = [17, n37];
```

## A single linked list

```rust
// if starting is n17
null = [];
n37 = [37, null];
n99 = [99, n37];
n12 = [12, n99];
n25 = [25, n99];
n17 = [17, n37];
n17
// remove all the unused
null = [];
n37 = [37, null];
n17 = [17, n37];
n17

// inline it
[17, [37, []]]
```

## Memory

```rust
// the whole, 10
null = [];
n37 = [37, null];
n99 = [99, n37];
n12 = [12, n99];
n25 = [25, n99];
n17 = [17, n37];

// inline everything, 16
null = [];
n37 = [37, []];
n99 = [99, [37, []]];
n12 = [12, [99, [37, []]]];
n25 = [25, [99, [37, []]]];
n17 = [17, [37, []]];
```

## Tree

```rust
n5 = [5];
n11 = [11];
n4 = [4];
// next line
n2_2 = [2];
n10 = [10];
n6 = [6, n5, n11];
n9 = [9, n4];
// next line
n7 = [7, n2_2, n10, n6];
n5 = [5, n9];
// root
n2 = [2, n7, n5];
```

## DAG

```rust
n5 = [5];
n11 = [11];
// next line
n10 = [10, n5, n11];
n6 = [6, n5, n11];
// root
n7 = [7, n10, n6];

// same as
n5_1 = [5];
n11_1 = [11];
n5_2 = [5];
n11_2 = [11];
// next line
n10 = [10, n5_1, n11_1];
n6 = [6, n5_2, n5_2];
// root
n7 = [7, n10, n6];
```

## Graph

```rust
// hoisting
a : _;
b : _;
c : _;

// cyclical data
a = [a, b];
b = [c];
c = [a, b];
```
