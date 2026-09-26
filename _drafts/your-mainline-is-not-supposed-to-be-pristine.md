---
title: "Your Mainline is not Supposed to be Pristine"
layout: post
categories:
  - Software Engineering
  - DevOps
tags:
  - "Continuous Delivery"
  - "Trunk Based Development"
  - DORA 
---

A common fallacy is the belief that the mainline is supposed to be pristine in a Continuous Delivery/Trunk Based Development environment i.e. that we pursue a deployment pipeline that we should eliminate all failures before integration. Not only is this untrue, I will argue that the pursuit of this implicitly assumed requirement is even hurtful to the flow and creation of value. This does not mean we should not adequately test our code, but merely that we must learn to rely on the signals we get from the deployment pipeline.

Obtaining an always green deployment pipeline gets more and more difficult as you scale your development organization. One common approach is to hide changes behind feature branches -- where changes can be checked before reaching the mainline.

This works, most of the time, but it also creates a culture where people are afraid of breaking the deployment pipeline by merging into the mainline. This fear leads to larger, less frequent merges, and longer integration cyclea and is one of the main arguments against feature branches in the first place [4] [5].

Implicitly, we create a culture where we optimize for Mean Time Between Failure - State of Devops [1] and subsequently DORA [2] teaches us that the key metrics for measuring throughput and quality are

- Deployment Frequency (i.e. how often we push or merge and as a result run the commit stage)
- Lead time for change (Time since the commit or MR was created until it landed on mainline)
- Mean Time to Recovery (How long it takes from a red mainline build for changes to be resolved and go green again)
- Change Failure Rate (How many mainline builds go red vs green)

If we want to reach these goals in production, it naturally follows we need to do it at least just as fast in our development environment.

Ironically, code changes are not the only source of failures -- and the developer making the breaking change might be unable to do something about it on their own, which only increases the fear of making changes. According to Continuous Delivery [3] there are 5 likely reasons why a pipeline might fail

- There is a bug in the application code
- There is a bug or invalid expectation in a test or testcode
- There is a problem with application configuration
- There is a problem with the deployment process
- Theee is a problem with the environment

Only some might be directly influenced by the developer, which will of course add onto the fear (and the DevOps organization must work towards breaking those barriers)

## Normalize and Standardize Reversals
Mean Time to Recover is greatly influenced by the ability to simply undo the commit - either by removing it from the mainline entirely or by reverting the commit, i.e. adding a commit that undoes the change.

To help adoption of this behavior, make sure it is well documented as part of the normal development flow. This will help to ensure the operation is carried out uniformly throughout the organization - in case of problems that will make more people able to help debugging when the normal procedure fails.

## Lower the Blast Radius of a Failed Deployment Pipeline
Reductio as absurdum, when you try to protect yourself against failure in the deployment pipeline, you must run the entire pipeline in isolation and test on a complete shadow environment setup.
This will quickly become an expensive (and likely error prone) affair as it scales horizontally with the amount of Work in Progress.

The problems begin when a developer has checked in code that fails and other people are standing in line to check in code too but are being blocked by tooling.

Getting the pipeline back into a successful state takes at least two times the time it takes to get a red signal and is still lower bound by the pipeline cycle time. For a job that runs in three minutes the team can barely get back from a coffee run, for one that takes 15 minutes you might as well go to lunch.

Splitting the deployment pipeline into individual jobs where you can get feedback earlier will help you to quickly answer if you are blocking other peoples work. In Continuous Delivery this distinction is in fact made, where the fast feedback is provided by the "commit stage" whereas the slower running "acceptance stage" then figures out whether this is something that can actually be released.

The key is to distinguish between "fast vs slow" running tests - only check the things that are fast and help the next developer out such as

- Verifying the code compiles
- Verifying system invariants e.g via static code analysis checks such as linting
- Verifying downstream integrity by running unit/regression tests

All the other quality checks come after as they do not provide value at this stage, probably even verifying the deploy-script - remember that a merged MR or feature branch does not mean the feature is necessarily done.


## Empower and Educate
People are in general inclined to "do the right thing" -- at least as long as it is easy. Continuous Delivery practices and flow optimization in general are not always intuitive, what benefits the greater development organization might impose requirements or restrictions on upstream teams. Education is a continuous necessity as there will inevitably be turnover (if not, you have other problems of stagnation to solve), it is not enough to say "we do <semantically diffused buzzword>" here. The processes, and rules must be restated in the organization's own language explaining what feature branching or Trunk Based Development means here, and what the expected behavior is. Never assume people read the book or even bothered googling it. A process document where the last change was a few typos three years ago does not count. Any process that does not change repeatedly is a dead process.

Naturally, to motivate the right behavior you also need to make people able to perform whatever operation is required, opening a ticket is not behavior. One side of the coin is the fast feedback (in a readable format) that can tell the developer "this was your doing" - but whatever the developer inadvertently broke, she must also be able to resolve on her own accord (and know how to)

## Measure and Improve 
Nothing speaks like a radiator with clear-cut data showing the organization where we are (and where we want to be) - one of the impediments, and probably hazards is that it forces us to define with mathematical precision, and come to terms with reality, how we measure productivity and how effectively we actually work.

Using the translated DORA metrics, as defined earlier in the post, my personal recommendation would be to target

### Build Frequency
Continuous Integration practices say integrate at least daily, so we should aim for at least the same number of builds as we have developers. We can measure it by increasing a counter every time the build starts.

### Lead Time for Change
In isolation this metric is easy to game, but together with the frequency that changes come
in it becomes hard to fake - we can choose to get the MR creation time from the code repository service or, perhaps more universal, the time of each created commit if possible. How to obtain this value very much depends on the tooling and branch/merge rules - one more good reason for standardization of processes.

There are many reasons this value might get skewed, normally I see work paused because of priority changes (and this is one thing we want to combat) - other reasons might be vacation or sickness. This is an indicator though that people might not check in frequent enough.

### Mean Time to Recover
We need to track not only every build, but also the final result of the job paired with timestamps.
Tracking this as a time series we can filter out and compute the mean time difference between the first red job until the next green one.
We can also choose more direct approaches if MTTR is the only value we are interested in but we need these values to also calculate  the change failure rate.

The target MTTR is a conversation that needs to be hels and agreed on between relevant stakeholders, as well as an agreement on when it is appropriate to roll back other people’s changes.

### Change Failure Rate
Now that we track the result of each individual build we can calculate the proportion of builds that fail.

At this stage we are only aiming for "good enough" -- fast feedback is often more valuable than exhaustive feedback at this stage.

For production environments, high performers have a CFR of 0-15% [1]. In the early stages of the deployment pipeline we can afford to aim for a higher failure rate of perhaps 20% and then lower the acceptable rate as we progress through to the next stages.

[1] https://dora.dev/research/2016/2016-state-of-devops-report.pdf
[2] https://dora.dev/guides/dora-metrics/
[3] Continuous Delivery -  Dave Farley, Jez Humble
[4] https://youtu.be/v4Ijkq6Myfc
[5] https://a4al6a.substack.com/p/stop-using-pull-requests