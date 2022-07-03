---
layout: post
title: Application metrics for asynchronous workflows
---

# Application Metrics for Asynchronous Workflows

Here are some metrics that I deem universally relevant when applying metrics to my application code when dealing with asynchronous workflows. Depending on what I want to achieve I will also add more metrics, however, to me, this is the baseline.

These metrics are relevant for each individual `step` as well as for the entire workflow. In the text I will just refer to this on a per step basis (a workflow with number of steps = 1).

For telegraf/influxdb I label a metric for my workflow and track indivdiual steps using tags.

```
myworkflow,step=first-step field_value=field_key 123456789
```


## Unit of work

This is a counter that goes up every time a job is processed. Together with the counter, I track succeeded and failed jobs.

I don’t keep a separate counter of incoming jobs, as that usually does not provide me with any value. With telegraf/influxdb you get that count for free if using tag values for success/failure.



## Timing

Timing metrics is relevant for the entire workflow as well as individual steps. If I have more than one asynchronous step. 

### Cycle Time

This term as well as the next one I stole from kanban terminology meaning “time to produce one unit of work” - i.e. this is the execution time of the background process.

### Lead time
In kanban, lead time is the duration from an order arrives until it is fulfilled. For asynchronous workflows I meassure it from queue time until the process is complete. I.e. The end time for cycle time and lead time is the same, and lead time > cycle time.


