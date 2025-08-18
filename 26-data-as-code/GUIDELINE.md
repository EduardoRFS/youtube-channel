# Code as Data Structures

Just water today.

Code reasoning as data structures.

Some of the most useful mental models that I know.

Also, there is a related topic after the end.

## Starting

"code as data" as embedding data structures.

People talk about "code as data".

The Lisp people mostly means homiconicity.

But code is data, it is in some form of memory.

Today is not about string or AST. But about data as code.

Thinking about data in a high-level way.

## We need a language

Always a language.

Only data, Let, arrays and strings.

There is no function, those are about code.

Check the example.

Using Rust blocks because of the amazing syntax highlighting.

## Linked List

Linked List a good first data structure.

Linearly recursive with indirections.

Lexical scope so this is reversed.

Let models indirections.

Variables are absolute pointers.

This is a common design for linked list.

Node is a pair, null is a reserved pointer.

Null doesn't need to exists.

## Contextual Rewriting

Code points to a single node.

We don't care about the entrypoint.

There is a technique from contextual rewriting.

A context is a term with a hole, generally a single hole.

This will be useful later.

This is only a meta tool, plugging.

## Environment

A common one, the environment.

It's a context, but a specific one, just a bunch of lets.

This is like the whole program heap.

A data structure is an "instance".

Those two are the same. Different entrypoints.

Everything will be using an environment, I will omit the hole.

## Shared Linked List

Back to the initial linked list.

Adding two nodes.

The linked list nodes are "shared".

This is why let.

Let is also about sharing.

You can "inline" it.

## Memory

A related topic, reasoning about memory.

We first need a model.

Uniform memory model.

Naive but practical model GC collected languages.

Everything is variables are pointers, tuples are flat, numbers are fixed size.

Proxy, the sum of the size of all tuples.

So inlining it, uses more memory.

But it uses more "memory".

## Trees

Trees, also recursive, but not linear anymore.

You can be more casual with notation.

First element is the value, rest is references.

Again, this is reversed.

## DAG

Sharing of trees.

You can "expand" the sharing.

It uses more memory, but it's just a tree again.

## Graph

There is one missing type of indirection, cyles.

Need recursive let.

Here I will be use hoisting.

So, a, b and c are already defined.

Doesn't need to use lexical order, but way more complex.

## Limits

What about arrays and pointer arithmetic?

Limits of the model.

But you can have better models.

No model is perfect, but some are more useful than others.

## Conclusion

Next step, put this in context.

A model for time complexity and you can reason about complete programs.

The examples will be on the github below.

This is mostly it for today. Bye.

Okay, now drink some water, follow me here and on twitch and come back in 15s.

I've been going to the gym, good stuff.

Also, having a lot of progress in my language, but it's a lot of work.

Okay, now that only the most masculine and straight men are left.

Let's talk about time.

## Time

For that we first need a model of computing.

Reductions instead of instructions.

This doesn't always work, but it's good enough for now.

## Another language

Another language.

Let, numbers and addition.

## Rewriting rules

I skipped how the language works previously.

Two rewriting rule.

Our model of performance will be "how many reductions happened".

"do the subst" and "do the addition".

"fired" anywhere, any order.

Let's go over two options.

add first, then subst.

Subst first, then add

If you assume 1 reduction per second.

We call those strategies.

## The Substitution Calculus

Let's go to a more concrete language.

The lambda calculus with let and numbers.

We will need the environment again.

A nice take, explicit substitution tradition.

First rules are the same.

But now there is beta at a distance.

At a distance because, beta would block.

## A bad model

Almost works.

Cost of reductions is different.

Cost of the same reduction also different.

A beta at a distance is more expensive.

It's still useful.

But it's more complex than counting.

## Value Substituion Calculus

An even better system.

A value is a subset of terms.

Only do substitution if it's a value with let.

Move the let to outside.

Weird but it works.

It's a restriction.

Cannot do the subst first path.

Many good properties, it's reasonable.

With another restriction, limiting to weak case.

You can just count reductions for both time and space.

## Linear Substitution Calculus

Another system, basics another video.

Great to model on paper.

It's more flexible than all the previous ones.

There is a nice relationship to proof nets.

Let's make the context explicit.

Ignore the stuff in between let and the variable.

The context bits is just sugar, not real.

A substitution at the time.

Can delay collection.

Great to model a garbage collector.

No more references, you can clear.

Can skip useless substitutions.

## Conclusion of second part

Which one to use?

Depends on the model.

They're just techniques.

By mixing, reason about time and space.

You can choose the granularity needed.

Well, that's it for today. Bye.

Go away, there is nothing more here.

But follow me on places.
