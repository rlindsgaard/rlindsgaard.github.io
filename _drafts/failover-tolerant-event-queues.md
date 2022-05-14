---
layout: post
title: "Failover Tolerant Event Queues"
categories:
  - Software Engineering
---

# Failover Tolerant Work Queues

This post describes an application and pattern to implement
on the application level for ensuring that all jobs queued
will be processed.

## Problem
Simple work queue systems such as Beanstalk, Mqqt and even more elaborate sofware solutions such as Kafka, Redis, Rabbid MQ are tolerant for failure in the sense that they will not forget a job.

However, when dealing with a failover system the assumption is that the state they use, unless replicated to the failover encironment, will likewise be gone.

This can be handled on the infrastructure level by simply replicating the queue software state. However, that requires architectural consideration - and requires a lot more moving parts (and thus things that may break) for replication. Potentially you get perfomance penalties as well as every queue/unqueue operation will have to be replicated.


## Application


## Requirements
- Persistent replicated state store. We will assume a structured database but it can just as well be a file.
- An asyncronous work queue
## Design
- Grapviz drawing
- Application state/workflow
### Checkpoint
### Recovery
 
## Example
## Idempotence/Side Effects

## Summary
- 