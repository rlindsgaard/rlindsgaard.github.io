---
layout: post
title: "A Workflow for Tracking and Addressing Operational Defects"
categories:
- DevOps
- Software Engineering
---

In an ideal world, defects are analyzed and resolved immediately, ensuring they never recur. In reality, however, resolving defects often relies on the tenacity of individual soldiers -- or even plain luck -- this approach leads to a culture of silos and uneven workloads. Even worse, without a structured problem-solving approach, other issues such as resource problems can mask as defects going on unnoticed or addressed indefinitely.

Defects refer to anything that functions unintentionally, while operational defects typically require manual intervention or tracking through automated observations. This post introduces a structured workflow for teams to collaboratively detect, track, and resolve such issues. It emphasizes structure and communication across functions and responsibilities. 

I will argue how the data collected can be used by the team and decision-makers to prioritise fireproofing. It is not an all encompassing terminology-worthy methodology, just a starting point for any team to start working with these issues in a structured manner.

> Imagine a case where a rogue process forgets cleaning up after itself after analyzing a file upload i.e. many files are written to the temporary directory, eventually exhausting the disk. There are load-balancing in place, for other reasons, and this particular thing happens once in a while on one out of 4 replicas. The machines are normally restarted for other reasons (it is the default first step resolution method) and is usually handled when half the fleet is down.

## Issue Tracking
Tracking issues by registering them is a tedious task and requires the kind of overview you don’t really have. Tickets are the backbone of almost any task management workflow so there is an almost certainty this will allow you to implement the workflow with existing and known tools.

We need two types of tickets. I will call them "bug" and "task" but their type is not important - how they function within the team’s workflow is.

The bug-ticket is a collection item and must be able to aggregate task-tickets into a child/parent relationship. The bug-ticket potentially lives for a long time in the backlog. 

The task-ticket follows normal board workflow. This is the sort of task the "expedited" lane or "unplanned work" is actually for.

With the overview of the structure in place, let us look at how to handle observations.

### Handling Observations
A new task-ticket is created on each observation. 

#### Naming
Use some convention of title e.g `Handle: "<error-message> "on "<instance>"`

1. The static prefix "Handle" becomes recognizable from glancing over summaries what class of tickets this belongs to
2. *error-message* is that nice juicy explanation of what actually happened. e.g "Full disk usage" or "Out of Memory" Most often you will find that sentence in a log or from the monitoring dashboard. This will most likely carry in some form of the bug-ticket title as well.
3. *instance* is the identifier of what machine or workload this was observed on. If you have multiple replicas you will want to know which one. e.g. "worker_fa4cd67e" or "service-db-2".

A naming convention ensures overview and readability for the human eye as the backlog grows, and helps include a minimum of relevant information.

The handler (or handlers, preferably) should make a best effort attempt at evaluating whether the observation is a known defect, or a new one. This classification helps determine what the right course of action is. It is also a great opportunity to communicate with your team and leverage collective knowledge "Hey we’re seeing this -- has anyone observed it before?"
In the team, you should agree on a distinct course of action when no precedence can be found that ensures it can be properly found and triaged at a later point in time.

> The team registers two tickets -- one for the bug and one for the observation, linking them together. (`No space left on device` and `Handle: "No space left on device" on replica-2` respectively).

#### Description
The primary objective is to collect evidence. Attach stack-traces, log outputs. Images of the monitoring visuals. You are the criminal investigator of a crime-scene - you don’t know what details are relevant so collecting comprehensive evidence is key.

Most important is:
- Making a record of the actions taken.
- Recording what state you can of a system before doing any destructive operations (i.e. if you clear a folder due to full disk utilization, what is actually on there filling it up will explain something).

> The week after, replica-1 goes down. Same error message `No space left on device`. The team remembers the bug ticket from last week and knows it is the same thing. 
Running `ls -lah` on `/` reveals `/tmp` to be the culprit, containing a large number of files with varying size. The `/tmp` folder is wiped, restoring the service. The actions and output is added to a new ticket`Handle: No space left on device on replica-1"` which is linked back to its parent.

### Classification
The bug-ticket represents the continued learning about; the bug in the machinery.

Focus is on iteratively filling in the description of the bug as we get wiser, allowing understanding to build up over time whilst keeping cognitive load low. For a first iteration, a copy/paste of the first observation ticket description will do. When we classify and triage early, we immediately start homing in on the pattern and cause of the defect.

From the initial task we likely know "how to identify/remedy" right from the start. As more observances are made, we might get smarter - i.e. instead of restarting the whole machine, we just have to restart this service. Start recording "next steps for investigation" (this is why you triage when handling, there might be clues as what to record or what actions to take next time around) - e.g If the disk fills up recurringly, we might want to start investigating what files or  workloads are present when it errors.

This structured approach will slowly reveal the root cause or appropriate mitigation of the defect to you and your team. Not only do you know the cause - you managed to track observances which mean you can extract the data of 

- How often does this happen?
- What is the impact?
- (When) will this happen again?

These are questions you need to answer to make a case for working on a defect a priority.

> The following week, disaster strikes again this time hitting replica 2 and 4. The week after next replica 3. Every time `/tmp` is filled up with some weirdly named files of varying size. The team can now show that there is something going on and it seems to hit the machines one by one. They manage to make the case to set aside time to investigate on the next sprint. One member of the team believes to have found the coding error causing this issue. It is all written down into a ticket linking back to the issue.

With the root cause and patterns of the defect identified, the next step is to prevent it from recurring again.

### Fireproofing and Remediation
You might think you managed to get to the root cause of an issue and fix it just to experience the same errors come popping up.

Addressing a defect is distinct from tracking and observing it in the wild, and separate tickets should track that progress. Luckily it goes well within this workflow and structure to track other work done relating to the bug-ticket -- we can attach all of those work items alongside any observation.

> The issue is found to indeed be a temporary file not deleted after processing an upload. This strikes a debate on handling of temporary files and one team member finds a good article upskilling everyone.

In some cases you need to delegate work to other teams - in which case the context we are creating with this workflow becomes even more valuable. Make sure to properly fill out those tickets with relevance, business value and expectations. Also remember to respect their cadence and workflow.

> A similar issue with temporary files elsewhere in the codebase is highlighted - this time it is not in the team`s own code but in another service - another ticket with a description of the potential issues and a description of the remediation is made, linking back to the bug. The ticket is then assigned to the colleague team. It makes it onto their next sprint without any back-and-forth.

## Wrapping Up
There you have it, a structure to work with that provides all the data you need with the tools you probably already have at your disposal and use every day. From here, it is up to you, and your team, to make use of this workflow and resulting structure for analysis, data-driven decision making, and remediation, to tackle big or recurring problems incrementally, instead of repeatedly, together.