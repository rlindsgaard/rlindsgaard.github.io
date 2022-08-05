---
title: A pragmatic approach to SOLID design
categories:
  - Software Engineering
---

# Pragmatically Applying Design Principles When Writing and Designing Code

Understanding design principles such as _SOLID_ or
_Composition Over Inheritance_ can be hard enough as they are
abstract. It takes practice getting it right, and it is not really
something that can be checked via static code analysis. Furthermore,
there is usually more than one path to getting the result.

This post will not be about any principle in particular, but instead
about how I apply those principle in practice, and more importantly
_when_ in the process of development I apply those practices.

## Growing Your Software
As of late, I have been reading and watching much material that
draws similarities between software engineering and gardening, more
than architecting and building buildings. I subscribe wholeheartedly
to that analogy as that very much describes how my process looks
like. Enough of that analogy, I only ventured there to make a point:

- Running code is alive, or need to be. It needs to grow into being
  and it needs care. Once it has matured, it can live mostly by
  itself, but when we start writing the code we know only little
  of how it will look like in the end.

I for one have been fooled many times over by designing systems
up front in order for priorities to be shifted mid-way. To mitigate
this, I rigorously apply tracer bullets and the extreme programming
practice of quickly punching a hole. This makes me stay agile,
in the sense that changing directions is fairly easy.

Getting feature complete is a matter of iterative _refactoring_,
which brings me to

## Another Analogy
When working on a greenfield project, we do not have much to
work with. It is a clean slate, but it is also a time of many
insecurities. Usually, we have some sort of idea of what we are
about to get ourselves into, we know enough to _sketch_ a design
or architecture.

I sometimes draw, I think I am actually quite good at it using
guides and everything. That makes me draw up (get it?) this analogy.

The initial sketch is good, we have a general idea of the main
components that need to interact, where they will be placed - or
at least a suitable place. So, stop analyzing and get to business,
don't worry about the principles just yet (wait, remember [KISS](https://enterprisecraftsmanship.com/posts/kiss-revisited/) and [YAGNI](https://enterprisecraftsmanship.com/posts/yagni-revisited/)).
Crank up the volume on your headset or whatever gets you going
and get writing some code (also don't forget your TDD practices,
they're going to be _very_ important going forward.)

Oh, and _NO_ [DRY](https://enterprisecraftsmanship.com/posts/dry-revisited/)ing. Everything is [WET](https://dev.to/wuz/stop-trying-to-be-so-dry-instead-write-everything-twice-wet-5g33)/copy-paste.

![How to draw an owl](/assets/draw-an-owl.jpg)

## Welcome to round 2
Ok, you nailed that first user story! You punched a hole and you
got a sunshine scenario working. It may be running on stilts,
but the tests pass. (and btw, if you did not write a complete
end-to-end component integration test, now is the time to get
back to your test-suite) - because we are now ready to refactor
for great good.

And refactoring means testing for regressions, constantly. And
component integration tests ensures that you do not forget to
update the interfaces between the already moving parts.

Waaait a second. Interaction between moving parts maybe calls
for some [design by contract?](https://en.wikipedia.org/wiki/Design_by_contract)

But first, get those changes committed, reviewed and deployed.
Then, you're ready for your, first no-brainer refactoring. Get
started on a schema that formalizes the structure. You got yourself
some tight coupling there so that part should maybe put into a
shared library between the two components.

Don't worry about having to deal with tests, you already wrote those.
You maybe need to change the in and out on your components' unit
tests but your integration test should be steady as a rock - you're
just checking for regressions. If you find that you are starting
to meddle with the component integration test, you're overstepping
your boundaries just now (except maybe for some renaming of imports)

There is a possibility that other _smells_ accumulated. Personally,
up to this point I have usually been somewhat inconsistent with naming
(it takes me some working with code and terminology before getting
it, almost, right... I never get naming right). In practice, I
start removing abbreviations in variable names and make sure all
methods are verb-phrases, all the code smells I can think of really.

With experience, you will know yourself well enough to know what
you usually let lying around. Might as well take care of it immediately.

Also, *DO NOT* DRY yet.


## Round 3

Time passed, you had a breather because the system needed to get
running on the double, and then something else caught your POs
attention... And you needed to fix this bug you left lying around
in another system, and also your cat ate your commit and... Aaanyhow.
At least you probably had a weekend or a chance to sit back and
think about the mess you made thus far. And your PM calls you
up saying "I got some new exiting task for you, and PO wants it
yesterday for this customer demo who will cancel anyhow".

Great, you got another task, and new requirements to make some
more lines -- and maybe also start using an eraser. You
can begin to see where the code is heading (ok, you probably knew
already judging by watching the waterfall that already accumulated
on the project roadmap and backlog).

But this is good. Now we start getting a glimpse of the future
of this code. Until now, we really just did some pre-germination or
some sketching. Now it's time to take a new pencil and start
drawing some actual lines. (this analogy is really working for me!)
You can start making plans for your code. And you have a very
real idea of what you focus needs to be. It is the immediate surrounding
of the lines (of code) or components that are making it into the
changeset.

A word of caution, remember not to go full retard here. I have
been caught here too many times myself thinking "is this SOLID?
Ugh, which way does the composition arrow go? what do I need to
do to get it just right?" Just don't.

It is a waste of your time. Or, it is not a complete waste, but your
time is better spent elsewhere so it is a waste of your employers
time and your _wild-ass-guesstimate_ is closing in on its due date.
The important part is, your code is maturing, and it is
solidifying (and maybe a little bit of [SOLID](https://blog.bitsrc.io/solid-principles-every-developer-should-know-b3bfa96bb688)ifying too?) which means
you also start being able to make better judgments about the
immediate future of the code, based on the lines you are actually
changing.

If you are anything like me, you will also start identifying the
pieces of the _main_ code that really ought to be dragged out
into subroutines, split up or rename components, ordering function
arguments etc.

You may start DRYing now. But consider if things should not still be WET.



## Rinse Repeat
This is it, it is this pattern iteration applied continuously
to use ones best judgment and applying [the boyscout rule](https://www.stepsize.com/blog/how-to-be-an-effective-boy-girl-scout-engineer) ad-libitum.

You can now start running down the checklist of favorite principles
to apply, and then just start applying them. One by one.

At this point, you can also got nuts with one component or feature
at the time. Just remember to keep those PRs small and edible.

![Drawing an owl](/assets/owl-2.png)

As a senior developer I have witnessed refactoring is
something developers needs to be encouraged to do (especially
if they did not write the code they are changing in the first
place and they have no ownership).  I regularly get "but it has
already been reviewed" or "Let us do it some other time" when suggesting
refactoring. I have a feeling the resistance is really due to it
being seen as an admittance that "If I refactor, it must mean I
was wrong the first time around and I don't like admitting that".
If that sounds like a familiar I hope it helps to remember that

A garden is never perfect, it is filled with living things
requiring attention and it needs to be taken care of constantly.
Sometimes, in order to grow, plants also need a little bit of
time, or moved into or out of the shade. Sometimes they need to
be trimmed or cut, or nurtured. Some plants just die, some gets
replaced for other reasons. In any case, the garden needs a caretaker
or it will either overgrow or rot. Likewise will code.

![Harder Better Faster Stronger](/assets/harder-better-faster-stronger.jpeg)

## Final Words

Here goes, I hope this inspired you. I know design principles can
be hard to follow, not just understand, but also apply. This is written
with the intention of giving some pointers as to how a senior engineer
goes about obtaining quality code. If you aim for perfect, you
never get done. So just take one small step in the
right direction, with each and every commit.
