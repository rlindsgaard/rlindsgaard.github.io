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
- An asyncronous work queue system
- A Locking Mechanism to avoid multiple processing executing the job.
 
## Design
- Grapviz drawing
- Application state/workflow
 

### Overview
The design makes use of the persistent state in order to generate a _checkpoint_ when the work is submitted, we need to store all information in the state that is needed to do the computation which is usually passed directly as to the background worker.



When a background worker starts processing the job, it is checked out by locking the job. 
Once the job is complete, the checkpoint is removed.


### Checkpoint
Before submitting the job to a queue, we will create a _checkpoint_ in the persisent store. This checkpoint should store all the data needed to complete the job. This is a replica of the current state of the queue, however it contains only the parts we need in order to start re-scheduling and start processing jobs on the failover system.


In postgres we can do this as a trigger to keep the operation atomic. Atomicity is not strictly needed here though.

The values necessary for a checkpoint

- id
- scheduled
- 


### Application State
### Atomicity
### Recovery
#### Manual Recovery
#### Automated

## Example
## Idempotence/Side Effects
## Pub/Sub
## Pipelines

## Summary
- 