---
layout: series
title: "A Pattern for Recoverable Asynchronous Work Queues"
categories: software-engineering
tags: application-design
series: foo
---

This is an application design pattern for ensuring jobs being allocated
on a transient queue are recorded and recoverable in the event of
node failure.

The pattern uses persistent storage in form of a database that is
failure tolerant.

There are queue systems that can deployed to the application architecture
such that this pattern becomes obsolete/redundant. If you have
control over the deployment architecture or need a hand wish for a failover
tolerant queue system I would advise you to look up e.g. Kafka or
RabbitMQ.

# Scoping the problem
We want to ensure that all jobs that have been queued will be
processed even after a system outage, e.g. process existing jobs
on a failover system. The queue system may be transient, i.e.
tolerant of restarts, but during a failover, the system will
start with an empty state and forget about everything that was
otherwise waiting in line.

Job1 -> Job2 -> ... -> Job n

Failover

Job n+1 -> Job n+2 -> ...


# The application design

# Dispatcher responsibilities

# Worker responsibilities

# Recovering

# Atomocity - or the lack thereof
