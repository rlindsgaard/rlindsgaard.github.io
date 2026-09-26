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

A common fallacy is the belief that the mainline is supposed to be pristine in a Continuous Delivery/Trunk Based Development environment -- that we pursue a deployment pipeline that we should eliminate all failures before integration. Not only is this untrue, I will argue that the pursuit of this implicitly assumed requirement is even hurtful to the flow and creation of value. This does not mean we should not adequately test our code, but merely that we must learn to rely on the signals we get from the deployment pipeline.

Obtaining an always green deployment pipeline gets more and more difficult as you scale your development organization. One common approach is to hide changes behind feature branches -- where changes can be checked before reaching the mainline. Merge Requests is a normal way to obtain this workflow and we will use the terms interchangeably.

This works, most of the time, but it comes with the risk of creating the wrong culture, one where people are afraid of breaking the deployment pipeline by merging into the mainline. This fear leads to larger, less frequent merges, and longer integration cycles and is one of the main arguments against feature branches in the first place [4] [5]. 

If we are not careful, then we, implicitly, create a culture where we optimize for Mean Time Between Failure (MTBF) -- State of Devops [1] and subsequently DORA [2] teaches us that focusing on improving Mean Time to Recover (MTTR) is a better way to reach high performance.

The key metrics for measuring throughput and quality are for production environments but we can apply the same analogue thinking to the deployment pipeline as this is just a shorter feedback loop, for the commit-stage, consider tracking

- Integration Frequency (i.e. how often we push or merge and as a result run the commit stage)
- Integration Lead Time (Time since the commit or Merge Request (MR) was created until it landed on the mainline)
- Mainline Recovery Time (How long it takes from a failed commit-stage job to be resolved and succeed again)
- Build Failure Rate (The rate between succeeding and failed commit-stage jobs)

If we want to reach these goals in production, it naturally follows we need to do it at least just as fast in our development environment.

Ironically, code changes are not the only source of failures -- and the developer making the breaking change might be unable to do something about it on their own, which only increases the fear of making changes. According to Continuous Delivery [3] there are 5 likely reasons why a pipeline might fail

- There is a bug in the application code
- There is a bug or invalid expectation in a test or test code
- There is a problem with application configuration
- There is a problem with the deployment process
- There is a problem with the environment

Only some might be directly influenced or caused by the developer, generally flaky tests and/or infrastructure will add onto the fear -- the DevOps organization must work towards breaking these environmental issues. If a developer cannot tell "I broke it" from "infrastructure broke it", fear persists.

## Normalize and Standardize Reversals
Mean Time to Recover is greatly influenced by the ability to simply undo the commit - either by removing it from the mainline entirely or by reverting the commit, i.e. adding a commit that undoes the change.

To normalize this behavior, make sure it is well documented as part of the normal development flow. Standardization means more people throughout the organization can help recover, and makes it easier to debug when the standard procedure fails.

## Lower the Blast Radius of a Failed Deployment Pipeline
If you try to eliminate all failures before the mainline, you must run increasingly expensive validation: full pipeline runs, shadow environments, comprehensive test suites. This will quickly become an expensive (and likely error prone) affair as it scales horizontally with the amount of Work in Progress.

The real problem emerges when a failed build blocks other developers from integrating.

Recovery typically takes at least twice the pipeline cycle time. One cycle for getting a failure result and another for verifying the pipeline now succeeds. For a three-minute pipeline, that is six minutes and one can barely make it back from a coffee run. For a fifteen minute pipeline, this adds up to thirty minutes -- that is several lunch breaks throughout the day.

Splitting the deployment pipeline into individual jobs where you can get feedback earlier will help you to quickly answer if you are blocking other people's work. In Continuous Delivery this distinction is in fact made, where the fast feedback is provided by the "commit stage" whereas the slower running "acceptance stage" then figures out whether this is something that can actually be released.

The key is to distinguish between "fast vs slow" running tests - only check the things that are fast and help the next developer out such as

- Verifying the code compiles
- Verifying system invariants e.g via static code analysis checks such as linting
- Verifying application correctness via unit tests

This check should be bounded to match the team's attention span, typically between  3-10 minutes. This could be an important metric to measure as well separate from integration lead time.

All the other quality checks come after as they do not provide value at this stage, deployments and deploy-script validation typically runs later as failed deployments do not block other developers - remember that a merged MR or feature branch does not mean the feature is necessarily done.

To protect later stages from failing prematurely we can make use of feature flags until the code is finally ready. We are thus de-coupling integration from deployments and we can safely collaborate with teams without jeopardizing the production release. 


## Empower and Educate
People are in general inclined to "do the right thing" -- at least as long as it is easy. Continuous Delivery practices and flow optimization in general are not always intuitive. What benefits the broader (development) organization may impose constraints on individual teams. Education is a continuous necessity as there will inevitably be turnover (if not, you have other problems of stagnation to solve), it is not enough to say "we do <semantically diffused buzzword>" here. The processes and rules must be restated in the organization's own language explaining what feature branching or Trunk Based Development means here, and what the expected behavior is. Never assume people read the book or even bothered googling it. A process document where the last change was a few typos three years ago does not count. Any process that does not change repeatedly is a dead process.

Naturally, to motivate the right behavior you also need to make people able to perform whatever operation is required, opening a ticket is not resolution, it is escalation. One side of the coin is the fast feedback (in a readable format) that can tell the developer "this was your doing" - with a clear indicator of what inadvertently broke. The other side of the coin is that they must also be given permissions and knowledge to be able to resolve it on her own accord.

## Measure and Improve 
Nothing speaks like a visual dashboard (sometimes called an information radiator) with clear-cut data showing the organization where we are (and where we want to be) - one of the impediments, and probably hazards is that it forces us to define with mathematical precision, and come to terms with reality, how we measure productivity and how effectively we actually work.

Using the adapted DORA metrics, as defined earlier in the post, my personal recommendation would be to target

### Integration Frequency
If the deployment pipeline is triggered on changes to the mainline we can simply increase a counter every time the build starts and select the period we wish to get the rate for e.g. daily. For periodic based triggering mechanism we need to find another mechanism such as closed MRs.

Continuous integration practices advocated for integration work at least once a day, where more modern day practices advocate for even more frequent integration. This is an opportune time for the organization to discuss and agree on the target rate.


### Integration Lead Time
In isolation this metric is easy to game. But together with integration frequency, it becomes harder to fake - we can choose to get the MR creation time from the code repository service or, perhaps more universal, the time of each created commit if possible. Integration Lead Time should be calculated from the earliest commit timestamp in the MR/feature branch to the timestamp when that change is merged into the mainline (i.e., when the merge commit is recorded).

There are many reasons this value might get skewed, normally I see work paused because of priority changes (and this is one thing we want to combat) - other reasons might be vacation or sickness. In general this is a signal that people may not be checking in frequently enough. Long lead times often indicate batching or delayed integration.

### Mainline Recovery Time
We need to track not only every build, but also the final result of the job paired with timestamps.
Tracking this as a time series we can filter out and compute the mean time difference between the first red job until the next green one.
We can also choose more direct approaches if MTTR is the only value we are interested in but we need these values to also calculate the build failure rate.

The target MTTR is a conversation that needs to be agreed on between relevant stakeholders, as well as when it is appropriate to roll back other people’s changes.

### Build Failure Rate
While DORA’s CFR measures production failures, we track commit-stage failures as an earlier signal to catch issues before deployment.

Now that we track the result of each individual build we can calculate the proportion of builds that fail.

At this stage we are only aiming for "good enough" -- fast feedback is often more valuable than exhaustive feedback at this stage.

Accept an initial high failure rate, say 20-30%. As the system stabilizes and flakiness in the environments or test-suites are addressed the targeted failure rate can be lowered.


[1] https://dora.dev/research/2016/2016-state-of-devops-report.pdf
[2] https://dora.dev/guides/dora-metrics/
[3] Continuous Delivery -  Dave Farley, Jez Humble
[4] https://youtu.be/v4Ijkq6Myfc
[5] https://a4al6a.substack.com/p/stop-using-pull-requests