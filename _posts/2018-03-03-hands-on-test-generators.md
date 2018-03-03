---
layout: post
category: code
title: A Hands On Walk-through of Writing Test-generators
---

## Introduction
So, you have learned to write yourself some unit-tests, and now
a friend of yours told you that your teststuite would be benefit
from using test-generators. You have googled what that is, and
you are now trying to apply that knowledge into writing some
test-generator based unit-tests. But how to do that?

That was pretty much my own experience before I learned to use
this nifty tool. I have since seen other people struggle with the
exact same things I used to. In this post I will present the
pattern and thought process I go through when writing test-generators
for unit-testing.
I will even finish off with a little rule-of-thumb I use to
determine whether to use test-generators or not.

I have used python2.7 and [nose](http://nose.readthedocs.io/en/latest/)
to develop the code in this post, the pattern should be applicable
to other languages as well without much change. I trust you are
familiar with setting up a development environment to run the
code on your own box.


## Getting Down to Business
Let us start with a small snippet of code we want to test. The
average value of a list of numbers:

{% highlight python %}
def mean(xs):
    return sum(xs) / len(xs)
{% endhighlight %}

A very simple and useful function that is not in the python standard
library. It is, however, still complex enough to allow us to write
a proper little testsuite using test-generators.

When writing test-generator based tests, I always start out with
something in the line of

{% highlight python %}
def test_feature():
    tests = [
        # (params, expect),
        # ...
    ]

    for params, expect in tests:
        yield check_feature, params, expect


def check_feature(params, expect):
    actual = feature(params)
    eq_(actual, expect)
{% endhighlight %}

That is, a test function being identified by nose iterating over
a list with tests defined as tuples (they unpack nicely in python ;).
The function then yields a helper function (thus making it a
test-generator) - I always prefix these helpers with `check_`.
`params` and `expect` are passed to the check-function. Basically
`params` contains the arguments to pass to the function under
test, and `expect` contains the expected result.

Now let us apply this to writing a suite for testing `mean`.

{% highlight python %}
def test_mean():
    tests = [
        ([1, 2, 3], 2),
        (range(10), 4),
        ([1, 1, 2, 3, 5], 2),
    ]
    for params, expect in tests:
        yield check_mean, params, expect


def check_mean(params, expect):
    actual = mean(params)
    eq_(actual, expect)
{% endhighlight %}

Nice and easy! I replaced `feature` with `mean` and added a couple
of tuples. However, the avid reader might have noticed a couple
of problems with the implementation of `mean` - or at least
identified some undefined behaviour.

This might not be an issue, but I believe in doing future me a
favour by documenting expected behaviour in the tests. This way
I have a better chance of knowing whether I did a stupid or not
(i.e. is it a feature or a bug).

First, I will define `mean([]) -> None`. That is easily implemented
by a guard

{% highlight python %}
def mean(xs):
    if not xs:
        return None
    return sum(xs)/len(xs)
{% endhighlight %}


and a test

{% highlight python %}
def test_mean():
    tests = [
        ...
        ([1, 1, 2, 3, 5], 2),
        ([], None),
    ]
    ...
{% endhighlight %}

And now for the final trick! There is a `TypeError` exception to
check (it happens when you, for instance, invoke `mean(['a'])`).

The `check_`-helper will look like this:

{% highlight python %}
def check_mean_except(params, exception):
    with assert_raises(exception):
        mean(params)
{% endhighlight %}


What I find myself doing most often though, is adding an item to
the tuples of the original list with the name of the callback
to use for the test.

{% highlight python %}
def test_mean():
    tests = [
        (check_mean, [1, 2, 3], 2),
        (check_mean, range(10), 4),
        (check_mean, [1, 1, 2, 3, 5], 2),
        (check_mean, [], None),
        (check_mean_except, ['a'], TypeError),
    ]
    ...
{% endhighlight %}

I could write a separate test-generator `test_mean_exceptions`
to cover exception checking and keep it separate, however,
this way I only have to look at one place to see what is being
tested.
*Note: If I add more items to the tuple, I usually go for a
`dict` instead, or place a comment on the top with what the
tuple contains.*


## The TL;DR
The final test-module now looks something like this (notice the
very small change to `test_mean`):

{% highlight python %}

def test_mean():
    tests = [
        # (callback, params, expected)
        (check_mean, [1, 2, 3], 2),
        (check_mean, range(10), 4),
        (check_mean, [1, 1, 2, 3, 5], 2),
        (check_mean, [], None),
        (check_mean_except, ['a'], TypeError),
    ]
    for func, params, expect in tests:
        yield func, params, expect


def check_mean(params, expect):
    actual = mean(params)
    eq_(actual, expect)


def check_mean_except(params, exception):
    with assert_raises(exception):
        mean(params)
{% endhighlight %}

There you go! There is a multitude of ways to apply this, but for
me the code usually evolves from this. Play with it, use it for
anything you like (except for doing evil).


## When to Apply This Pattern
Although there are other applications when to use test-generators,
For utilizing this pattern my rule of thumb is that whenever I
make use of a for-loop and there is an assertion inside it, this
pattern is aptly applied.
