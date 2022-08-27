DRY or _Don’t Repeat Yourself_ is an acronym often used as a synonym to de-duplication. In this post I will try to discuss not as much the differences between

## A word on clean functions
- Always a verb or a verb phrase, functions do things. The name should
- Do one thing
- Step down
- Always use kwarg names
- Separate Query and Command (do one thing)

## Control-flow Parameterization

I consider this form of de-duplication a direct anti-pattern.

In it’s simplest (and most innocent) form it looks something like this

```
def foo():
    abstract_func('foo', True)
  
def bar():
    abstract_func('bar')
    
    
def abstract(param1, param2=False):
    result = ''
    for _ in range(10):
       result += param1 
    
    if param2:
       with open('func.txt', mode='w') as f:
       f.write(result)
```

There is a lot of things wrong with this example (I had to conjure something simple, please imagine something more complex) - but in terms of de-duplication the abstraction does not make sense, but the code works because the calling code controls the behavior of underlying code.

The “abstraction” is simply wrong, and ought to have looked something like

```
def foo():
    abstract('foo')


def bar():
    abstract_bar(abstract('bar'))


def abstract(param1):
    result = ''
    for _ in range(10):
        result += param1
    return result  

def abstract_bar(result)
    with open('func.txt', mode='w') as f:
        f.write(result)
```

### The danger lies in the evolution

After you’re done. Another developer comes in and needs to do the same, print and then save. She finds the abstraction and thinks “hey, that’s just what I need to do” (accidental simlar toplogy). She then works the abstraction a bit (it’s easy) to work with ints as well.

[example]

Now, later you come back and removes `foo`



## Inheritance-based control flow

You might be tempted to another de-deplication attempt where the control-flow happens via named functions. The above example would look like

```
def foo():
    abstract_foo(‘foo’)
    
def abstract_foo(param1):
    abstract(param1) 


def bar():
    abstract_bar(‘bar’)


def abstract_bar(param1)
    result = abstract(param1)
    with open(‘func.txt’, mode=‘w’) as f:
        f.write(result)
        

def abstract(param1):
    result = ‘’
    for _ in range(10):
        result += param1
    return result

```

## The Problem with Control-flow abstractions
- Function should do just one thing
- Open-closed principle. I.e an abstraction should work like a black box
- Adds intrinsic and germane cognitive load
- Undoing the abstraction is hard and will most likely result in even more
 

## Accidental Similarity de-duplication

In basketball and handball respectively, you dribble a ball. The rules of dribbling in the two games are very similar. The “computations” for dribbling, i.e. the muscle groups etc. are exactly the same.


### Inheritance over composition

- Tight coupling
- Easily turns into control-flow when similarities end
- 
 
This pattern is an effect of choosing inheritance over composition. I have been the culprit of this myself until understanding that principle fully (hint: it does not only apply to objects)

It happens when we start in different places and their codepaths merge - we have two different things with to different business policies, and they just happen to have the exact same policy, right now.

We are developers and we are quite good at spotting patterns, so naturally if we mingle it about we can explain it in the exact same way.

In the best case, those policies never change. But the abstraction has a tendency to add an immense cognitive load as more variables are introduced in order to tell “which of the paths we’re in”.
It can be explained the same as it is the same operations we perform on both, but the “result” are two different things. And the return type you would have to define using… inheritance.


Worst case, but if the policies should change, you will most likely see the control-flow anti-pattern in effect .

It is not an anti-pattern per se, but I highly discourage it as it falls under the “composition over inheritance” principle.


## Maybe(DRY)

- Discouraged
- Premature DRY
- Hard to undo, risk of turning into control-flow parametrization

Is it business policy, an abstraction or is it a way to save some lines of code. If it is the latter, you trade lines of code for intrinisc cognitive load. Furthermore, there is a high risk another developer wants to re-use it (it was DRYed already, must be for a good reason) - so instead of undoing the de-duplication, she adds a parameter for her special case (it’s the easiest thing to do) - moving the code into the control flow parametrization anti-pattern.

If this is a business policy, e.g a specific way to specify or ensure order, or an abstraction in order to save typing characters you may be on to something though as you will be defining “inherent behavior”


### Clean Abstractions
If you think you are on to something, but there is argument as to whether the code ought to be de-duplicated - or you are not entirely sure you got inherent behavior yet - consider this design


```
def func1():
    func1_partially_abstract('foo')
 
 
def func1_partially_abstract(arg):
    truly_abstract(arg1, arg2, arg)


def func2():
    func2_partially_abstract('bar')


def func2_partially_abstract(arg):
    truly_abstract(arg1, arg2, arg)
 

def truly_abstract(arg1, arg2, arg3):
    # work on arg1, arg2, arg3
    
```

This design has a couple og benefits

- It is declarative, as you clearly separate arguments that are there due to the abstraction and which ones are actual values passed through.
- You can “switch” back from truly_abstract without changing any of the calling code. I.e. later WET operation becomes cheaper
- Should a third occurence occur where control-flow parametrization would be likely - it is likely possible to make this control flow part of the partial function, keeping truly_abstract truly abstract.


## Inherent Behavior

aka the DRY-principle applied


### Business Policy
Business policy may be defined by the business as specific requirement such as “a number must always be displayed with us formatted thousand separator” or “all amounts must be displayed in the user configured currency”

It can also be defined by technical staff. “All timestamps must be stored in UTC” - basically, all the inherent rules about writing code that you did not realise you needed to learn to get your PRs approved when starting this position that had nothing to do with whether the code was working or not.

For the most part, these things “ought” to have been abstracted away via the platform, but have materialized in such a way experienced staff simply does it without thinking about it.

But guess what - policies change. Government policies, organization policies - even senior developers policies of what constitutes best practice. At least if they’re worth anything, otherwise they stopped learning.


### Informal Interface

Have you ever tried having to “do things a certain way” in order to get the code to work?
Define specific variables or arguments that your code needs to take, and maybe pass on to the underlying system without you ever touching it?

That is an informal interface you need to adhere to.

The best thing here is to formally define that interface as it is a text-book example of when you need a layer of abstraction in order to not repeat yourself.

That abstraction layer and formalised interface may be a big refactor and re-design away in order to get right as there are probably more moving parts that need to fit.

An alternative is to take just the offending parts and wrap around your code, simply hiding away the “stuff you don’t need”


### Boilerplate code

Sometimes, you just want to save some characters. You’ve written this stuff numerous times before and it always looks the same because it is really just an extension of the standard library code, applied to your domain.

One thing I almost always end up adding to a util mode my projects is

```
def read_json(filename):
    with open(filename, mode='r') as f:
        return json.load(f)
```

Another one is such a good DRY example that it has now actually made it into the python standard library:  datetime.isoformat()


### It _is_ the same thing



## If in doubt, leave it out



