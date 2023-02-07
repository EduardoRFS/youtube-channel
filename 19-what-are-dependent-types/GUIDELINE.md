# Guidelines

## Introduction

Today I will be trying to show even more magic, this time we will be doing type wizardry.

In previous videos I was discussing functions, what they are and how "eliminating" a function is enough to compute, you can find those videos <points-to-corner>.

- You know, youtube stuff, don't forget to like, subscribe and enable the notifications. Let's go.

Everything that I do here will be explained better in future videos, but let's play a bit today.

## Introduction to a language

I'm currently making a programming language called Teika and as Teika is obviously the best language. So the examples here are gonna be in something similar Teika.

If you want to know more about the progress, I do live streams on twitch almost every day, coding Teika, OCaml, Coq and Rust sometimes.

## Goal

The goal today is to internalize how substitution works and how it applies to everything. So let's first imagine a simple language, there will be no compiler.

<show lambda, forall and type>

We also need to know the type of everything to ensure it type checks.

This language has "everything", simple functions, accepts a term and return a term, type constructors, accepts a term and return a type, type to term aka polymorphism and term to type aka dependent types.

<show each>

Another very useful tool here to avoid noise is to imagine alising.
<show example of let alias>

## With our language, let's play

What can we do here? The answer is almost everything, it is actually turing complete because of Type in Type, but let's ignore that.

There is a way of representing data, which is called church encoding.
<show examples of booleans>

<use booleans to show dependent types>

## Why is this useful?

The first 3 kinds of functions are not special, you probably know from your TypeScript, maybe not higher kinded types, but you kind of have intution for it.

But what do we win from dependent types? The answer are tests or in a fancy way proofs. And now I'm gonna say something very deep, that you could probably spend years thinking of it. TYPES ARE PROPOSITIONS AND TERMS ARE PROOFS.

What does that mean? This is a proposition that a boolean number exists, so this can be read as "assuming a boolean X, exists it returns a boolean".

How are those tests? Well, for concrete cases, we just need to define equality.

<show leibniz equality>

So let's write the proposition that "not true" is "false" and "not false" is true.

<write the proposition>

How is this a test you may ask? Because if you try to assert that this is the same as reflexivity, the language will execute the code and that will fail at compile time if the test fails.

<show example>

## Let's get real

I will be doing a couple similar examples in Coq, feel free to pause the video and try to understand it, but the main idea is to show that this holds or doesn't holds.

<show not example above>

In fact you can even show negatives if you have induction.

<show example of true not being false>

## One last step

You may be wondering, what is the advantage of traditional unit tests, we could discuss this for a long time, but for me the major one is that you can write proofs for infinite values.

<show example of 0 + n being equals to n>

This says that 0 + n is ALWAYS equals to n, no matter the n. This one specifically is kind of easy.

But to finish, this, let's show an example, the opposite.

<show example of n + 0 being equals to n not holding by refl>

<show example of n + 0 being equals to n holding by induction>

## Well that was it

If you want to know more, follow me on youtube, twitch and twitter. Bye.
