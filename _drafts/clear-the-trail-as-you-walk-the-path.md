---
title: Clear the Trail as You Walk the Path
layout: post
---

There are many guides on what kind of technical debt should be
acceptable, and even discussions on whether technical debt is
avoidable and something that should be battled. Personally, I
think accumulation of technical debt is a symptom of the wrong
programming culture and unskilled personnel.

I personally get the jitters by technical debt, something that
might have been right at the time but obviously is not anymore.

The perfectionist in me would like to tackle on all technical debt
as I see it as a slippery slope to actual code rot and legacy projects.
However, the pragmatist in me knows that I am a one man army, and
just like my home, with two children below school age, even though
you apply constant vigilance, you still end up with mess in
various corners.

Some things need to be tackled on a department/company level,
or require substantial effort. But as I see it, that is a symptom
of someone, or a group of people accepting a status quo that
allowed a small fire to grow.

A philosophy and principle I apply to ward off technical debt
is to "clear the trail as you walk the path". I am sure that
I found this proverb in a book, I just can find it to quote it.

What it means is simply, even though there may be substantial
things wrong in a code-base and you know a bunch of things that
you want to fix and restructure - undertaking all of it is a
complex task, it requires discussion, and most likely before you
are done, one or more people have come in to add or change behaviour
such that you are stuck in a rebase and fix loop. (Yes, it has
 happened to me a number of times)

I'm a strong believer in the boyscout rule: "Leave the campground
cleaner than you found" and one might argue this is the same thing.

It is, from the sense that it tells you what to do, it does however
also tell you _when_ and to what extent to apply it. As with programming
paradigms, and all other sound design principles, the power lies
in what _not_ to do.

You narrow down the scope of what you should do to the immediate
path that you are tackling with for this feature. Just as you
_only_ clear the path, and do not venture out into the forest
to collect garbage.

That means, for our purposes of software development, the current
execution path of your changeset. All the other things there may
be wrong, forget about it, just narrow down and say, for this
particular execution path, how can I pay it forward or make that
better.

My theory, or belief, is that once you come back and your changes
cross this path, it is a little bit better, and then you
add on another addition that makes this particular execution path
a little bit better.

These changes will compound, and eventually, the only commonality
for the execution paths is the framework or overall structure of
the code, and then you automatically start tackling the large issues.

## A good
