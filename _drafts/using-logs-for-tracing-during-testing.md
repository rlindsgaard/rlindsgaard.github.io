---
layout: post
title: Using Logs for Tracing During Testing
---

# Using Logs for Tracing During Testing

When developing (and thus testing) I usually find myself issuing a bunch of traces, especially when something is going wrong and I can’t put my finger on where it is things fall apart.

Sometimes it is a series of complicated procedures and I want to ensure subroutines are invoked and possibly in the correct order.

That can end up with a whole series of `print` statements throughout the code that needs cleaning up as a preparation step for peer review.

One time I remember finding myself cleaning up for review and then adding the same traces back again continuing my work.

Furthermore, I like the practice of fuzzy tests generating randomized input or “fixtures” for my tests - making it necessary to also issue `print` statements of the setup functions as well.

Finally, I am one of those developers who has a tendency to add Given/When/Then or Arrange/Act/Assert comments for my future self or others.

I don’t like to clean up the code, and I know for a fact those traces help debug bugs as well. 

All this has made me pick up a new practice bringing all this together. It never comes close to anything as dirty as `print` statements in production code and only moderate cleanup is necessary. Furthermore it gives a very nice and useful trace when developing.

It goes a little something like this...

