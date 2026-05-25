---
layout: post
title: Ship/Show/Ask - The Flowchart
categories:
  - Software Engineering
---

Ship/show/ask branching strategy originally devised at Thoughtworks it is explained in full at [Martin Fowler's blog](https://martinfowler.com/articles/ship-show-ask.html) - it is designed to combine and leverage the benefits of both Trunk Based Development (TBD) and a Merge Request (MR) based development practice.


[Andrea Laforgia](https://a4al6a.substack.com/p/stop-using-pull-requests) gives a much better discussion on how this strategy can be used as a stepping stone for pure TBD, providing excellent reference material along the way.

In short, the approach categorise changes into three scenarios

**ship** - Small changes, side effect free, push changes directly to trunk. Perfect for fixes or otherwise side-effect free changes.

**show** - Create a merge request and merge it when it passed checks. Perfect for feature development where you don’t need work to get stuck in the "waiting for feedback" pit.

**ask** - Request and discuss feedback before going any further. Perfect for inter-team changes, newcomers to the code-base and re-designs


My contribution is the flowchart below combining the whole thing into a single decision tree from the perspective of an individual contributor.

![Ship/Show/Ask - The Flowchart v1](/assets/shipshowask.jpeg)

