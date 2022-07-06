---
layout: post
title: Separate the Entity from the 
---

# Separate the Entity from the ORM

I have long been practicing the behaviour of defining the entity as part of the database. 

It was what I was tought to do, and it has given me all sorts of problems in my business logic.

Although having given me all sorts of problems, I found myself unable to put a finger on where the smell was.

Reading Robert C Martins Clean Architecture finally made me able to figure out what I was doing wrong, and how to remedy. 

## The Database is a Detail

The TL;DR is that you should use the ORM and the database as just a “detail”, meaning all database operations are kept entirely separate from the application business logic via a facade by defining your entity first and foremost as a simple object.

The fact that the entity is stored in a database should not matter or be apparent directly from the application business logic.


## The problem(s)
- Professionally, I come from a python background 

but I reckon this particular bad practice is inherent 
I figure this is a very common python practice, and that my mentors have failed 

## The benefits
### Tracer Bullets and Small Iterations
When I start working, I have a good idea on how the entity will look like and I first and foremost want to start working on the application logic.

There is somewhat of a “cost” of having to deal with having to start defining the entity in the database.

We have all sorts of little policies such as naming conventions, defining timestamps for creation and update, database constraints, etc. A lot of mental overhead that has nothing to do with the task we are getting ourselves into, and in effect takes momentum and focus away from me.

Furthemore, when getting down into the task I find I am often missing an important field and need to make further schema adjustments. I figure this is because defining the database first is somewhat of a waterfall style of programming.

### Serializing Entities

It is difficult to serialise your ORM object for use with anything than the database. The reason is that the ORM object is very tightly coupled _to_ the database. However I find that most commonly I need to serialize the entity one way or the other at some point.

This is partially due to working service oriented, but also shows itself internally in the application when wanting to work asynchronously.

### Database Performance, connections and table locking



## Discussion
### But we are not Likely to Change the Database

The database is a typically a cornerstone piece and indeed we are not likely to change that anytime soon.

However, start

### It is just so Verbose
Yes it is. However it also goves structure and tells anyone else changing the application where things fit.

I bet not dealing with it from the get go is eventually going to incur more code.
[reference needed]

## Conclusion
