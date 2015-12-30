---
title: RndPhrase Roadmap
layout: post
---

The RndPhrase project is now getting large enough, that I think
it requires some writing on where things are going.. It's becoming
a combination of different projects ranging from the library implementation
as well as browser plugins and the website.
I am therefore writing a roadmap in order to keep my thoughts
straight about the projects, as well as doing some sort of
prioritisation to get me working on the actual important parts
and not what just comes to mind.

I will cover the current state of the different projects making
up RndPhrase and then make a more detailed description of where
each  of the three projects are going indivdually and then end
the post by specifying a combined roadmap and milestones.

## RndPhrase.js
RndPhrase.js is the library code, which have been implemented
in a modular approach in order to support use cases that are
not covered by either a browser plugin or a website.

Besides making the code work as an npm module a lot of changes
have been made in this part. I guess it makes sense since these
changes were also the requirements inducing further developmnet.

I will leave out the technical details, however the bulletpoint
headlines are

* Implementation as reusable module.
* Removal of selection bias.
* Support for four types of characters with constraints.
* Variable length passwords.
* Multiple versions based on same seed/password/domain.

It has been a long process designing the password generation
algorithms as well as the API. Some corners were cut and some
limitations were overcome.
The design, as well as the implementation is nearing completion,
however there are still three tasks to complete before it is
reading for moving into actual beta testing.

* Change the underlying hash algorithm.
* Make password generation asynchronous.
* Refactoring the library code.

Let us discuss each of these three tasks in detail.

### Algorithm change
I did a thorough review of the cubehash implementation, and found
several bugs, some of which were more serious than other.
The bug report is at https://github.com/RndPhrase/cubehash.js/issues/2.

I have supplied some patches to the code, however the patches
are not in the main branch yet, as they yield the requirement of
a major release.

I have had concerns using a homemade implementation of the most
critical part of the entire operation and these discoveries has
made me positive that the hashing algorithm using for the pseudo
random number generator needs to be changed into something more
trustworthy.

There is now an actual crypto API in the major browsers which
is standardised by W3C, so the change will be made into a
built-in algorithm. The PBKDF2 algorithm has been chosen as the
default algorithm in order to generate the PRNG. The hashing code
will be made modular though, so it will be possible to choose
different PRNG generators by just supplying a wrapper function.

### Asynchronous password generation
There are a lot of benefits working with asynchronous code and
when making heavy computations the need becomes more apparent
as the PRNG generation blocks everything whilst calculaing.
Furthermore the built-in crypto libraries themselves work asynchronously,
as well as browser plugin code, which just makes the switch to
event based code evaluation much more natural.

### Refactoring
The code needs to be refactored such that it properly implements
the needs of where it is supposed to be invoked.
Implementing callbacks everywhere takes care of a part of it.
However, after a long time of development and trying out things,
the code needs a major rewrite. The focus will be on implementing
a properly defined API as well as hunting, and removing, dead code.

## Web User Interface
The webbased user interface is the only thing that has been brought
up to date with support for the new functionality of the library.

It is hosted as a github page at http://rndphrase.github.io as
well as on https://rndphra.se. I suggest using the latter as
it will be turned into a "stable" version, whereas the former
will probably be unstable and used for testing/staging purposes.

The currently most recent tag (0.0.9.5) supports configuring
constraints on the generated password, the possibility
to define the used alphabet as well as allowing a version
parameter to generate multiple passwords based on the same credentials.

The user interface currently also supports the (now legacy) functionality
of the original RndPhrase implementation (http://rndphrase.appspot.com),
however that will probably be removed at some point in the future (
however, not before hitting a stable relase of RndPhrase).

I originally had an idea of making a separate GUI library as well
for generating forms and styles for the different uses and GUI
implementations, however that is currently postponed indefinitely.

On the immediate drawing board is the configuration of Let's Encrypt
on https://rndphra.se, however that requires an actual relase of
that software. Until then the https endpoint serves a self-signed
certificate. A couple of other loose ideas (not planned for any
implementation soon) are

* Calculator to show NIST entrophy password strength.
* Encrypted localStorage with domain configuration.
* An accompanying blog focused on password security

I believe the website is supposed to be a tool, so there should
not be too much eye candy, and it should be easy to ignore/navigate
around.

## Browser Plugins
Porting the browser plugin hasn't really got any attention up until
about now. However, now that the library is nearing completion
it is a lot more interesting to look at this part of the project.
There have been made some design changes which makes using RndPhrase
as a plugin a lot more secure. However, the entire API on how
to make plugins for firefox/chrome is changing a lot these days,
so the only progress that has been made currently just serves as
proof of concept.

## Project Roadmap
So, to come to a conclusion we'll prioritise the different tasks.

### Milestone 1: Completing the Library Code
This is the single most important part at the moment. It will be
done with a parallel implementation of the webbased user interface,
so as to make sure the specification actually works.
When I believe this to be complete, I will move the library
into an alpha release.

### Milestone 2: A Second Usage
As the next part of the project, I will start to focus on doing
actual browser plugin implementation besides just PoC code.
This basically requires mirroring the webbased user interface and
make everything work outside of the DOM.
When a second use of the library has been produced, the library
will be moved into a beta release state.

### Milestone 3: Peer Review
I believe that before making an actual release, this thing should
be peer reviewed. I will try to find at least two people that
are willing to go through and verify correctness.
Whenever the peer reviews are completed (and possibly, fixes are
made) the first stable release is ready.
