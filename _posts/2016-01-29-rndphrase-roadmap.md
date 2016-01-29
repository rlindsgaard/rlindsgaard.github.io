---
title: RndPhrase Roadmap
layout: post
---

The RndPhrase project is now getting so complicated, that I think
it requires some writing on where things are going. It is becoming
a combination of different projects ranging from the library
implementation into browser plugins and also a webbased tool.
I am therefore writing this roadmap in order to keep my thoughts
straight about the different ongoing projects, as well as to write
down a prioritisation to get me working on the actual important parts
and not just what comes to mind.

I will cover the current state of the different projects making
up RndPhrase and then make a more detailed description of where
each of the three projects are heading indivdually, and finally, end
the post by specifying a combined roadmap and define a set of milestones.

## RndPhrase.js
RndPhrase.js is the library code, which supports different javascript
plugin behaviours such that it can be reused for great good in
a way not directly attached to the scope of the rndphrase tools.

A lot of changes to the internals of RndPhrase has been made
to the library code in relation to the original implementation.
A majority of these changes was of course also the requirements
which induced further development in the first place.

I will leave out the technical details, but a list of the most
relevant changes are:

* Rewrite functionality to a reusable module.
* Removal of selection bias.
* Support for four types of characters with constraints (instead
  of a hardcided lower case alphanumeric alphabet).
* Variable length passwords and configured minimum size.
* Multiple versions based on same seed/password/domain.

It has been a long process designing the password generation
algorithm as well as the API. Some corners were cut and some
limitations were overcome.
The design, as well as the implementation is nearing completion,
however there are still three tasks to complete before it is
ready to move it into a beta test phase.

* Change the underlying hash algorithm.
* Make password generation asynchronous.
* Major refactoring of the codebase.

Let us discuss each of these three tasks in detail.

### Algorithm change
I have done a thorough review of the cubehash implementation and
found several bugs, some of which were more serious than other.
The bug report is at https://github.com/RndPhrase/cubehash.js/issues/2.

The issues at the time of writing has not yet been solved, although
patches have been supplied the entire library will need to be tested
properly. The changes are significant enough to yield a new major release.

I have had concerns using a homemade implementation of the most
critical part of the entire operation and these discoveries has
made me make up my mind that the hashing algorithm that is used as
the pseudo random number generator needs to be changed into something
more trustworthy.

There is now an actual W3C crypto API standardization, so the default
hashing algorithm will be changed into one with built-in browser support.
The PBKDF2 algorithm has been chosen as the default algorithm.
RndPhrase.js will implement the PRNG in a modular fashion such that
the PRNG can be customized with a wrapper function.

### Asynchronous password generation
There are a lot of benefits working with asynchronous code and
when making heavy computations the need becomes more apparent
as the PRNG generation blocks everything whilst doing calculations.
Furthermore the built-in crypto libraries themselves work asynchronously,
as well do the event handling browser plugin code.
Working asynchronosly is therefore the way to go.

### Refactoring
After a long process of developing new features and trying out ideas,
the code needs a major rewrite.
The interface needs to be streamlined, and there is code left
that simply does not need to be there anymore.

## Web User Interface
The web user interface is currently the only UI that works with
RndPhrase.js.

The current master is hosted at http://rndphrase.github.io and
should be considered unstable. A more stable version is found at
https://rndphra.se.
It currently supports configuring
constraints on the generated password, the possibility
to define the used alphabet as well as allowing a version
parameter to generate multiple passwords based on the same credentials
(for sites that require you to change passwords on a frequent basis).

There is also support for generation legacy RndPhrases, with functionality
duplicated from http://rndphrase.appspot.com.
It will most likely be removed in the future, but not before RndPhrase
Improved as a whole is released as stable code.

A couple of other loose ideas for the web user interface are

* Calculator to show NIST entrophy password strength.
* Encrypted localStorage with domain configuration.
* An accompanying blog focused on password security.

however there is no immediate planning for adding any of this.
The web user interface is primarily a tool, and should not be
cluttered up with too many unnecessary features.

## Browser Plugins
Writing browser plugins has been a quite difficult task for
various reasons.
The SDKs and frameworks for writing plugins in the major browsers
has undergone changes, making it hard to keep up.
Furthermore, developing plugins required a new design and development of
proof of concept code. All in all a fair bit of re-invention.
It looks like firefox and chrome now supports the same plugin
technology, and focus will now be directed to implement a proper
plugin for these two browsers.

## Project Roadmap
Let us come to a conclusion, prioritise the tasks at hand and
setup some milestones.

### Milestone 1: Completing the Library Code
Completing the library code is the single most important part
as it lies the foundation for everything else.
It will be done with parallel support for the new interface in
the web user interface to support usage testing.
When the three major tasks for RndPhrase.js is believed to be
completed it will be moved into an alpha release.

### Milestone 2: A Second Usage
The next job at hand will be to focus entirely on browser plugin
support.
In order to be complete, the functionality of the web user interface
will be copied.
It is yet to be decided whether the graphical code will be duplicated
or a separate repository will be made to handle UI code in a uniform
way.
When a successful implementation has been made, using the library
a second time, it will be moved into a beta state.

### Milestone 3: Peer Review
Before making a final release, the code needs peer review.
I believe that it requires a thorough review from at least two people
that are willing to check the entire code before releasing a final
version.
