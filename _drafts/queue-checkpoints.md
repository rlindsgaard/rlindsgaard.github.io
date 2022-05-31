---
title: “Adding checkpoints to your background work”
layout: post
---

# Adding Checkpoints to Your Background Work

At times it can be beneficial to add checkpoints when performing a set of background operations. 

Frequent applications I have encountered includes:

- Caching data that does not fit into the queue job size (a work queue is not a datastore).

- Exposing information on the progress of working with a large dataset.

- Working in parallel on the same data.

- Persisting state of the workflow for failover tolerance.

It also enables us to use in-memory message queues for the workflow, improving overall system performance. 

Each of these applications of course has different solutions as well. I prefer solving by supple design. This design works for virtualized as well as cloud environments.

## Architectural Overview

We depict it using a producer/consumer model

!(graphviz-image)[assets/queue-checkpoints-architecture.png]


The producer is responsible for adding the checkpoint. When computation completes, the consumer removes the job.

The idea comes from erlang [source needed]


## Choosing technologies

To get this setup running we need two technologies

#. A place to store the checkpoint
#. A message queue

### State

The state needs to be accessible by the workers. The

### Message Queue


## A Concrete Use Case

A customer sends us a list of items in a structured file for batch processing. When this happens we iterate trough the list, depending on the concrete item in our portfolio we query different suppliers for price and availability, add in our own policies and shipping prices in order to generate a daily price list.


## The State Schema

First of all, we need to find out where to store the checkpoints. 

Depending on the use checkpoints we can structure metadata around

- A single queue/worker — you can probably store the state in a flat file then

- A specific workflow

- A specific use case (DRYing similar business rules)
 
I prefer using a database, a bucket or a system file can also be used.

I use the following base schema

- A primary key column
- A field containing the queue name (for the latter two)
- A field with the payload
- A created timestamp

in postgres it looks like this

 ```
 create table checkpoint (
     id bigint serial primary key
     queue varchar
     payload text
     created timestamp
 )
 ```

## Submitting the background job

- Atomic operation?
- Background job arguments

## Processing the queue

- Checking out the data


## Loading the State

## Testing

- Functional test

## Telemetry
- Unit of work
 - succeses
 - failures
- Lead time
- Cycle time

## Applying the pattern

I mentioned the pattern was supple, let us dive into how to extend it for

### Large files

Large objects don’t go well in a database common and is to me an anti-pattern.

For this use-case, we write the file when creating the checkpoint, pass on the location.

!(large-files-example)[/assets/queue-checkpoints/pattern-extended-blob.png]


### Map/Reduce computation

There are different ways to do map reduce, one example is to keep track of the chunks or jobs and simply trigger

### Pipelines

For a pipeline, I like to add checkpoints whenever data is extracted from a third party source. If something should go wrong, the pipeline can be restarted from the last checkpoint.

This is really where the idea for this pattern comes from in the first place.




### Failover tolerance/Recovery
