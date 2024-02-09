---
layout: post
title: "Extrapolating the throughput DORA metrics directly from a git repository"
tags:
  - DORA
  - git
  - metrics
categories: 
  - DevOps 
  - Software Engineering
---

In this post I will explore a simple way to compute the DORA metrics that indicates throughput which involves no changes to the existing architecture of a VC/CI setup.

The purpose is to explore a method that allows for ease of experimentation working with the tools at hand to get started quickly with DORA as opposed to designing the perfect generic production setup.

If you need a primer on DORA metrics consider reading <https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance>

**The TL;DR:** Using gits built-in annotated tags to register when a release has been made, it is possible to use the “taggerdate” value og the reference. This can be used to compute the timedelta between each release to give the deployment frequency. Subsequently to obtain all commits in each release and compute the time between when the commit was made to the release time giving the lead time to release metric.

## Applications and limitations

For the example code the tag-system is expected to be used for releases only. It will probably take some customization and hardeking to get it working in a concrete scenario.The method will probably work in a simple pipeline structure as well as a fan-in pipeline structure. However the more sources you add and the more frequent changes are made, there is provably better ways to compute these values.
And of course, if you rewrite/squash history as part og merging etc, you will lose important pieces of data. Keep development in the trunk!

## Creating Tags
When a new release is made, it is necessary to get the CI pipeline or a manual tool to post an annotated tag back to the repository.

> $ git tag -a release-123456789 && git push origin release-123456789

Annotated tags are used as the timestamp of the tag creation time can then be used as opposed to lightweight tags that will only record the timestamp of the referenced commit. That might be ok for your use case.

### A comment on security
Beware that you do not inadvertently add a code injection vulnerability into your pipeline. Any acces from the automated pipeline to the repository should be with access to push tags only 

## Deployment Frequency
Deployment frequency is the time between deployments to the production system. I like to adopt the terminology of continuous delivery pipelines and use the term “release” instead of “deployment”. Given a deployment can be an internal deployment to a certain cluster etc of a release candidate. This mixed terminology has got me confused more than once.
In order to calculate the metric, we simply need to know the timestamps of each individual release and can then computethe mean of all the timedeltas between the releases.

```
def get_releases():
    cmd = "git for-each-ref --shell --sort=taggerdate --format='%(if:equals=tag)%(objecttype)%(then){\"ref\":\"%(refname:short)\", \"dt\":%(taggerdate:format:%s)}%(end)' \"refs/tags/*\" | grep -v \"''\" | sed -e \"s/^'//\" -e \"s/'$//\""
    output = subprocess.check_output([cmd], shell=True)
    
    releases = []
    for line in output.decode('utf-8').splitlines():
        releases.append(json.loads(line))

    return releases

def calculate_deployment_frequency(releases):
    deltas = []
    for i in range(1, len(releases)):
         deltas.append(int(releases[i]['dt']) - int(releases[i-1]['dt']))
    return statistics.mean(deltas)

```

*Authors note: I’m curious as to whether it makes sense to produce the mean of the entire history and make it “grow” or whether we should be looking at a specific window - e.g. half a year or one year back or a set number of releases. Another method would be using a moving average or mean - I believe that would either be a better indicator or just sugarcoating.*

## Lead Time for Change
The mean time to deploy is a bit more tricky to compute and requires the known timestamps of each and any change made as well as which release it is part of. We want to calculate the distance from all of these changes to the release timestamp. 
This will give us the metric for _one_ release, so we need to compute this for each changesets to each release.

```
def calculate_lead_time_to_release(releases):
    start = None
    deltas = []
    for release in releases:
        release['commits'] = []
        end = release['ref']

        r = f'"refs/tags/{start}".."refs/tags/{end}"'
        if start is None:
            r = f'"refs/tags/{end}"'
        
        subcmd = 'git log --pretty=\'{"ref": "%H", "ts": "%ct"}\' ' + r
        subout = subprocess.check_output([subcmd], shell=True)

        for line in subout.decode('utf-8').splitlines():
            cmt = json.loads(line)
            delta = int(release['dt']) - int(cmt['ts'])
            # Maybe bucket the commits into the release?
            # release['commits'].append(delta)
            deltas.append(delta)

        start = end
    return statistics.mean(deltas)

```

## Conclusion
I have shown a viable simplistic method for computing throughput metrics without a complicated setup making use of event handling and databases to get started using these metrics. The important part to me is how to obtain the relevant datapoints as they can be sliced and bucketed to any liking from here.

## Complete example script

```
#!/usr/bin/env python3
# Author: Ronni Elken Lindsgaard <ronni.lindsgaard@gmail.com>
# License: MIT

import subprocess
import json
import statistics
import argparse

units_of_time = {
    'days': 60*60*24,
    'hours': 60*60,
    'minutes': 60,
    'seconds': 1
}

def main(args):
    releases = get_releases()
    divisor = units_of_time[args.unit]
    print(f"deployment frequency: {calculate_deployment_frequency(releases)/divisor}")
    print(f"mttr: {calculate_lead_time_to_release(releases)/divisor}")

def get_releases():
    cmd = "git for-each-ref --shell --sort=taggerdate --format='%(if:equals=tag)%(objecttype)%(then){\"ref\":\"%(refname:short)\", \"dt\":%(taggerdate:format:%s)}%(end)' \"refs/tags/*\" | grep -v \"''\" | sed -e \"s/^'//\" -e \"s/'$//\""
    output = subprocess.check_output([cmd], shell=True)
    
    releases = []
    for line in output.decode('utf-8').splitlines():
        releases.append(json.loads(line))

    return releases

def calculate_deployment_frequency(releases):
    deltas = []
    for i in range(1, len(releases)):
         deltas.append(int(releases[i]['dt']) - int(releases[i-1]['dt']))
    return statistics.mean(deltas)

def calculate_lead_time_to_release(releases):
    start = None
    deltas = []
    for release in releases:
        release['commits'] = []
        end = release['ref']

        r = f'"refs/tags/{start}".."refs/tags/{end}"'
        if start is None:
            r = f'"refs/tags/{end}"'
        
        subcmd = 'git log --pretty=\'{"ref": "%H", "ts": "%ct"}\' ' + r
        subout = subprocess.check_output([subcmd], shell=True)

        for line in subout.decode('utf-8').splitlines():
            cmt = json.loads(line)
            delta = int(release['dt']) - int(cmt['ts'])
            # Maybe bucket the commits into the release?
            # release['commits'].append(delta)
            deltas.append(delta)

        start = end
    return statistics.mean(deltas)
    

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Calculate DORA throughput metrics')
    parser.add_argument(
        '-u', '--unit', help='unit of time', default='days',
        choices=['days', 'hours', 'minutes', 'seconds']
    )
    main(parser.parse_args())
```