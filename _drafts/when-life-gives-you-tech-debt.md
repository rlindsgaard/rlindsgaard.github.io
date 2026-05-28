# When life gives you tech debt: you make lemonade - the kaizen way
In this post I will give you a a personal strategy for targetting, not only technical debt, but also how you might turn frustration and apathy into a productive asset that works for you (and your carreer).

What I will present is my personal coping/dealing mechanism and mindset towards the dreaded "technical debt" of a large project that is bound to accumulate however well harnessed to give you

- improved inner work-life balance
- more focus/increased productivity
- slightly less technical debt

## know your enemy: not all technical debt is evil and you need to change your perception

I care very much about code quality from a developer point of view, tying things together so much that I have written linters for python/flake8 and even for commit messages. Learned how to use it to inspect code to generate documentation with guaranteed up to date constants and component interaction charts. DevEx is my domain and passion and has been even before the term "DevOps" was coined. Much of this interesting, but it also comes 

### Old one out, new one in: 

Understanding thermodynamics:
When on the topic of technical debt, a concern is often the increased entropy of the system tying, in terms of clutter but also coupling. This is understandable intuitively but the idea comes from thermodynamics, so let

Gardening metaphor: Go outside, I urge you to take green bath. If you have a garden of your own then think of that, otherwise, go to a nearby park or other "green" area that is kept. Pay attention to details - it is likely that, there’s a bush that needs trimming - grass is growing beyond it’s boundaries. By a tree, there’s a broken, and then sawed off twin, or a root bulking partially up. There are also more fundamental things wrong, cracks in the pavement or potholes - maybe there is wood on one bench that is deteorating. Now consider, what would be the things you need to take care of - and what would you leave around.
Overflowing trashcans and broken benches, those are features not working - a crack in a cement stone, that is likely that poorly defined function with a bad parameter buried deep within a single component that really ticks you off.


## no-one is going to prioritize a refactor (and neither should they)

### Good enough versus technically (academically) correct software
In "Modern Software Engineering" Dave Farley compares craftsmanship with engineering. That distinction resonates with me. As engineers, we need to first and foremost solve problems as cost-effeciently as possible. There might be the introduction of a new more modern technology that overlaps with existing one - so now we need to take on a refactoring project to migrate everything onto the new stack, right?

Stop right there! From a business point of view this is goldplating and completely unnecessary. The risk and added maintenance cost of a refactor far outweighs the known cost of keeping a stable system. Sure, it might look messy on the system chart - and somebody might cry DRY, but this is simply growth of a project.

Introducing new technologies, methods etc is *new* and as a consequence *immature*. It is not yet stable and it might prove to be the wrong path and the new technology will be the one replaced first  [choose boring technologies](yes I argued rewriting beanstalk to redis, good thing we didn’t, we ended up going a third way). Duplication of functionality and a prettier chart is not sufficient to warrant a refactor of any kind.
In 5 years, maybe 10 years when both have proven stable and usage patterns have been established, then yes, maybe, if it otherwise serves a strategic goal.

### Changing otherwise stable code has a chance to add more maintenance cost
The code has been running for a good while in production. It does its job, there are no complaints - but it no longer fits the perception of "good code" and there aren’t even unit tests to tell you what the code does.

Should you refactor such code just because there’s a new style guide in town or because it is not readable?

Unless there is an actual business need you should leave your hands off. Every code change you make is an increased chance of adding a bug - that then needs to be adressed adding more changes that risk adding more bugs. If the code is stable, until there is an actual need, you should keep it so and trust the battle testing that production has provided.
[drive by refactoring]

### The business does and should only care  about burning platforms 
In this context, a burning platform means that the business is unable to operate or expand if not adressed. I once worked on a team where we successfully managed to perform an entire python 2 to python 3 language upgrade and later a move of service instances from VMs to cloud operations. We also did a bunch of smaller stuff, some of it I was put personally in charge of - at the time I felt we needed to address more issues, looking back I am glad it didn’t get more attention.

The only architectural, big project refactorings that should get "priority" are the ones that really _are_ needed - by promising discontinued support, or by constraints to growth such as "you can’t get any more disks" - the business case you can describe vaguely to a non-techie and they still get it.

### Refactorings are (or should be) part of your day to day activity
"We need to set time apart to refactor" or "We need a refactoring sprint to cleanup" are anti-patterns, and it is not how [big things get done]. Refactoring is a tactical approach to obtain the target of a new feature or stability. 

You, and the team, are responsible for keeping code quality and doing what is needed to be done as part of feature implementation it involves writing proper test, writing the code well enough that it is changeable, and also updating documentation on it. What is necessary, a


### Wrapping Up
There is a reason this debt is there in the first place - although it might feel like debt because it is not new and shiny and alive - it actually isn’t "debt" at all - Your product owner knows this, your architect knows this. There is a difference between stale and stable and it is not just an added "b".

You are the technician and specialist aboard. Refactoring is a tool in your toolbox, and although you it wasn’t part of the curriculum, in the industry, you need to learn when you must use it and to what extend. 

- Refactoring can add maintenance cost
- refactoring is part of development activity
- the strangler pattern
- refactoring code vs business needs

thermodynamics
0th law

If two systems, A and B, are in thermal equilibrium with each other, and B is in thermal equilibrium with a third system, C, then A is also in thermal equilibrium with C

2nd law
the total entropy of a system either increases or remains constant in any spontaneous process; it never decreases

## clear the trail as you walk the path - how to percieve the process of tackling technical debt

So I guess you are quite offensed by now. Didn’t I promise lemonade and all I did thus far was piss on your parade telling you refactors are not necessary?! The secret lies in when and where.

Imagine a wooden trail within a forest. If no-one walks there, it will be re-claimed by the forest.
As you walk it, you help maintain it by treading down vegetation, or incidentally breaking off small branches. However if there is something blocking the path, like a fallen branch, what do you do? Go back? Walk around it? Clear the route for other passersby or your return journey?

### The strangler pattern - How big refactorings get done
Around march 2020, we removed the python2 executable from our base images. To me, this was a well executed process. It wasn’t some big isolated refactoring project burning all engines, exhausting engineers and postponing everything until the last possible minute. It started more than five years prior chipping away at a huge checklist.
First preparing the code so that the interpreter did not just throw up at first contact - then there was updating of dependencies to python3 supported ones, identifying and replacing discontinued projects (of which there was quite a lot) - and this was just the practical part, before that we even had shoot-outs and discussions as to whether py3 was to be the future. Of course it was also a training operation all the while through ensuring no new non-compatible code crept into the projects.
The take-away is that we did it slowly, little by little, project by project. Not once, but multiple times over battling a thing like "file encodings" as a separate thing, ensuring uniformity too.
It allowed us to look at the changes incrementally, in isolation, and not continue before work was complete (we did continuous deployments so our feedback was fenomenal).
This was an application (on multiple levels/granularities) of the strangler pattern.

 
We managed to 
To my memory, we started the python 2 to 3 porting project in 2014 - and we removed the python 2 executable from our systems in march 2020. From a structured approach that is, I know it started even earlier importing from future but 

### Observe the 0th law of thermodynamics
Cool name, huh? Apparently it was found after the first two and so fundamental they needed to index it first.

Talking about technical debt and code quality we often venture into thermodynamics and talk about the "entropy" in the system (or at least I do) - the metaphor comes from thermodynamics where we reference the 2nd law

> the total entropy of a system either increases or remains constant in any spontaneous process; it never decreases

src: https://openstax.org/books/physics/pages/12-introduction

The 0th law states that 
> If two systems, A and B, are in thermal equilibrium with each other, and B is in thermal equilibrium with a third system, C, then A is also in thermal equilibrium with C

Or, as the source text explains , for thermal energy to be transfered between two bodies they need to be in thermal contact.

As a computer scientist I am no stranger to metaphors (and beating it into I get from it what I want) - in this context I’d like to emphasize the contact part - when you clean up code or refactor, only make behavioral changes for the logic your (code) changes are otherwise in direct contact with in terms of execution path. 

As an example, even though a particular bad pattern or function call is used throughout a number of functions in your file, right here, right now, you are only changing the one function - if something is off further down the call stack, e.g a parameter - you may change this 

I’d like to follow that metaphor onto the rule of thumb of "The best time to refactor is just before your next change" - even 

## Kaizen: Just tie your shoe-laces

Here it is: Pick a pain. Every day, you take yourself aside some designated time-slot, let’s say one hour. During that hour, you scope down a small piece that is a solution to that larger pain - and you make the change. The important part, and the challenge, is that you must finish this off as an individual enclosed controbution. As a isolated merge request, a separate commit or in-line between other changes. It doesn’t matter, you are the final judge.

### The personal benefits
I don’t have any scientific proof, but try it out and I bet you will 

### Improved Inner work-life balance
There mere act of addressing an issue will help turning frustration and apathy into a more positive state of well-being. It’s like doing the dishes or finally clearing that drawer. Maybe it won’t hit you from the get-go, maybe you need to get into the groove first (like going to the gym) - but when you are there, things will start looking brighter and you will be satisfied with yourself.

more focus/increased productivity
Being frustrated, or maybe even obsessing is a constant annoyance and load that keeps your mind occupied from problem solving and focusing on other things.

less technical debt

How this will help you, the team, and the business professionally
- scoped incremental work
- improved code quality
- productivity
- culture

Conclusion
