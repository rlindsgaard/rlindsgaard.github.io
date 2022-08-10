# Antipattern:Parameter control flow

In this post I will talk about an anti-pattern I have dubbed “Parametrized cotrol flow”. This is merely my own short-coming of finding it named/explained elsewhere.

I see it mostly as a result of code DRYing. Whether it should be DRYed in the first place or simply WETed is another discussion.

I.e. it happens when we want to do the same thing for two different objects - resulting in sligthly different behavior

## The (anti-) pattern

A simple example is when the caller takes “charge” of the control of the subroutine. Here we have an order that is processed - depending on where i


```
def foo():
  baz()

def bar():
  baz(False)

def baz(bat=True):
  if bat:
    # Do something
  else:
    # Do something else 

        
```


## Why is it an antipattern?
### Cognitive Load
### Single Responsibility Principle
### Liskov Substitution Principle
### More Features
 
## How to Refactor
### Is it Premature DRY?

I have a personal rule of not DRYing a behavior until I see it at least thrice. I find that it is easier to DRY once you know the exact similarities than it is to untangle code that has been prematurely DRYed - usually because accompanying unit tests are tangled into the mix.

### Untangling the 

## Wrap up