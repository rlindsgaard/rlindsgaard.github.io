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

Each of these applications of course has different solutions as well. I prefer solving by supple design. This design works for virtualized as well as cloud environments.

## A Concrete Use Case

A customer sends us a list of items in a structured file for batch processing. When this happens we iterate trough the list, depending on the concrete item in our portfolio we query different suppliers for price and availability, add in our own policies and shipping prices in order to generate a daily price list.



## Save the State

First of all, we need to find out where to store the checkpoints. 

Depending on the use checkpoints we can structure metadata around

- A single queue/worker — you can probably store the state in a flat file then

- A specific workflow

- A specific use case (DRYing similar business rules)
 
I prefer using a database, a bucket or a system file can also be used.

A 


## Loading the State

## Testing

## Telemetry
