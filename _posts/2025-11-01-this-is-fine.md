---
layout: post
title: "This is Fine or: How I Learned to Stop Worrying and Embrace Technical Debt"
categories:
 - Software Engineering
 - Philosophy
---

As a developer I have always been passionate about incremental change and adamant about addressing technical debt, which I believe is deeply tied to code quality.

The most challenging part was reconciling my frustration towards colleagues and decision makers who did not seem to care about something I felt was of great importance -- even though I worked in a team where code quality was very highly regarded and prioritized, I wanted even more I wanted everyone to strive for the same perfection as me.

The fact is, it is never going to be enough quality or tidiness and you will always land back on a satisfactory level of 7 (or a 3?) -- not unless you can find a good metric.

There are many great lessons that experience, and philosophy, has taught me to harness emotions. Two of these I will expand upon in this post

1. The path is the goal
2. Love your fate


## The Path is the Goal

My unwavering focus on code quality and technical debt led me to explore systems design, build systems, and beyond. It has led to hands-on experience with the inner workings of tools to generate documentation and visualizations based on reflections of the code, abstract syntax trees for unconventional linting rules, and a myriad of templating and interpolation techniques.

This pursuit of quality has made me the engineer that I am today. I like that engineer.

I have also learned that the quality I sought was a golden calf. I have had the humbling experience of working on the same codebase long enough to witness the unintended consequences of my own work. One experience that stands out to me was a refactoring initiative I took on for the purpose of improving code quality -- years later, working with the same code I found my earlier assumptions to be false, and my "improvements" had made the code worse. This lesson, among others, has forced me to rethink my definition of code quality.

Quality is not about a uniform and tidy codebase, it is about adaptability. I have found that it is better to leave working code unchanged unless you absolutely have to, regardless of how it looks.

Coding guidelines and static analysis are invaluable tools for preventing code rot from setting in. I would not like to work on a project without them, at least at the integration stage. But be wary, as these things can quickly devolve into bikeshedding, with teams or individuals obsessing  over the wrong bottlenecks. The road to hell is indeed paved with good intentions.


## Love Your Fate
This stoic phrase (or Zen-Buddhist, take your pick) encourages us to accept things as they are. Only then are you free to act.

Code is the way it is because work has been done -- work that provided real business value. After all, that is our motivation for code quality, isn’t it?
It is okay; it is good code because it is what brought us here.
The design, the foundation, the toolstack too. It held up the codebase, it kept the business -- well, in business. Perhaps instead of calling it "debt", we should view it as battle scars.

Whether it is debt or not does not matter much; what matters is the next step you take. Make those steps towards internal acceptance, and practice identifying smaller increments to make. To identify the real bottlenecks, I have learned to ask myself where the real problems are, what obstacles prevent people from performing their work, and what difficulties new personnel must face. What traps do they consistently fall into?


## Conclusion
I have grown to a place where I think there is no such thing as "technical debt", I prefer the term "unmanaged complexity" which I believe was coined by Dave Farley.

I have realized that management or decision makers are not to blame or be held accountable for  poor complexity management -- and refactor is not the solution, that is a cop out. This is an engineering problem, a group problem and the two most effective things I can do to battle it is

1. Write documentation, and then write some more. Specs, tickets, commit messages--everything matters. As a senior, I know and understand the context and systems better than most. I understand the "whys" and the theory behind. That needs to be communicated -- or else everyone makes up their own explanations.
2. Spend all the time needed to help, show, discuss, review the work of junior staff. Sometimes it is skills or experience lacking. More often than not, they lack context. Even with documentation, gaining a true understanding of the system takes time.

I find that most often the poor complexity management comes from well meaning people who don’t know better because of lack of context and/or experience -- most often it is misunderstood attempts at making improvements that backfires into more complexity -- it is a socio-technical issue and I have transgressed into treating it as such.

By reframing technical debt as unmanaged complexity and embracing these lessons, I have found not just peace, but also a more rewarding inner work life.