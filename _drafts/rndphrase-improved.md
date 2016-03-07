---
title: Introducing RndPhrase Improved
layout: post
---

This blogpost covers a proper introduction to the RndPhrase.js
library. The cornerstone of what I call RndPhrase Improved.
It is based on RndPhrase, originally created and introduced by
Johan Brinch http://brinchj.blogspot.dk/2010/02/rndphrase.html|RndPhrase.

RndPhrase Improved is a rewrite of Johan's original implementation
which features a modular structure and improvements to the underlying
RndPhrase password generation algorithm.

I personally consider RndPhrase to be an invaluable tool, and
have used it extensively ever since I heard of it.
The original RndPhrase implementation never reached a stable release
as there were unadressed issues which never were adressed.
With the consent of Johan, I have taken on the task to develop
and maintin the project. As this is a total rewrite I have
named it RndPhrase Improved.

I will not cover the theory behind RndPhrase as such, as Johan
has already done that on his blog (follow the link in the first
paragraph). However, I will provide a
short description of the basic idea. Furthermore, I will cover
design changes to the code, the improvements that have been made,
and discuss the motivation behind these changes.

I will not include a security discussion in this post, as it
deserves a post of it's own. Rest assured, one is in the making.

## RndPhrase 101
RndPhrase is designed to replace the need of a password manager.
Instead of storing passwords in a database be it online like lastpass
or offline like keepass, it generates secure passwords on-the-fly,
so to speak, by using a hash function. And then use the resulting
hash as a (deterministic) psuedo random number, in order to generate
a password, that should hopefully be secure.

Three pieces of information are used to generate the hash.

1. A "master key" or seed, which is used globally. This is stored
   in the session, in configuration or similar. This one should
   be hard to guess.
2. A location (typically the domain of where the password is to
   be used. Eg. github.com). This one is more or less public
3. An easy to remember (and type) password, which is used whenever
   one would usually use a password.

When RndPhrase is used as a plugin, the seed is stored in memory
(hashed of course), the second is inferred automatically from
the location. Finally, when the user is prompted for the third
and final piece of information at login time in order to generate
the correct psuedo random number. I call this a deterministic
pseudo random number (DPRN).

The DPRN is now used to select characters from a pre-defined
alphabet. The result is a hard-to-guess domain specific password,
and the only way to crack it is to obtain all three pieces of
information, two of them a secret (known only by you), or to
find a hash collision.

## Looking back
The original RndPhrase implementation is a simple cross browser
plugin which listens on password fields and activates when an `@`
is typed as the first character. When the field's change event
triggers, it will generate a RndPhrase and replace the field
content with this value.
The master password is stored in the plugin configuration and
the context is gathered from the domain of the website where
the form is presented.

There is also a web user interface available at http://rndphrase.appspot.com
which provides the ability to generate the password when not
in your own browser.

The unadressed issues I mentioned earlier are:

* Passwords only consist of lower case alphanumeric characters
  and is not configurable.
* It is not possible to specify constraints such as a minimum/maximum
  amount of characters by specific types.
* Although almost insignificant, there is a selection bias.
* It is not possible to configure the hashing algorithm.
* The password generation method is not reusable, and consists of
  a mixture of javascript and make files.
* You can not configure password rules for a specific websites.
* Domain validation uses a frequently outdated file but requiries
  manual updating.
* The easy-to-remember password gets typed directly into the DOM
  of the website which makes it exposed.
* Websites requiring special charactes and/or frequent changes
  are a hassle.

## Improving RndPhrase
Now, some of these issues are user interface related whilst
others relate directly to the RndPhrase generation algorithm.

In order to stick to the point and keep focus, I will only address
the issues relating to the latter. I will cover the user interface
changes in another blogpost where I introduce in detail the
improved design of browser plugins.

Some of the functionality I describe hereunder is already implemented,
some is still a work in progress, see
https://rlindsgaard.github.io/2016/01/29/rndphrase-roadmap/ for
a status.


I am going to start out easy with some of the non-technical
design changes, and then move over to the more computer sciency
parts where I delve into the inner workings of the algorithm.

### Making Code Modular
There are several reasons to do this. First of all, having
a module makes it possible to provide an interface such that
it is easier to use in different implementations.
Furthermore, it separates functionality and user interface.

To use RndPhrase one only needs the library code available at
https://github.com/RndPhrase/RndPhrase.js.git or
https://www.npmjs.com/package/rndphrase.

The current plans are to develop and support the library,
browser plugins for Firefox and Chrome, and a web user interface
available at http://rndphra.se.

The projects are separated in different repositories to keep
unnecessary code to a minimum.

### Changing the DPRN
There is now a W3C standard for crypto libraries built into
the webbrowser. It does not make sense to rely on a custom implementation
of a hashing algorithm that also needs to be maintained, when
it can be avoided.
Cubehash is not part of the standardized API, so the default hash
algorithm needed to change. For this PBKDF2 is the best fit.
As it is also a well known hashing algorithm, it will hopefully
also make it more trustworthy.

The DPRN functionality is implemented in a modular fashion to
support usage in systems that does not adhere to the W3C standard,
such as nodejs. Making the library independent of the hashing
algorithm also makes it possible to provide support for other
hashing algorithms (suchas legacy support with cubehash).

### Event Based/Asynchronous RndPhrase Generation
Generating the hash with PBKDF2 requires some computation. It
makes sense to use the asynchronous version in order to not block
all threads whilst doing the computations.

The original RndPhrase implementation featured a synchronous
hash function. However, although the W3C crypto API standard
provides support for synchronous methods, it still blocks the
browser. Also, event based functionality are really
the correct way to do things in Javascript, using callbacks instead
of return values.

## Better Password Generation
I really wanted to improve RndPhrase
such that the shortcomings I mentioned in the introduction would
be mere memories. Adding versioning was a step up the ladder,
and in theory, it would be enough to add capital letters as well
as special characters to the alphabet and that would be enough
(of course I didn't stop there as you will see in the next section).
However, there was one problem that I needed to overcome.
Johan covers the alphabet and how letters from the alphabet are
chosen at his blogpost http://brinchj.blogspot.dk/2010/02/rndphrase.html
however for those of you too lazy to click the link I'll go through
it very shortly, the rest of you can just skip this paragraph.

The alphabet consisted of 36 characters - small letters and numbers.
By making a 256-bit hash this number can be split into smaller
numbers (it's just bits anyway) so splitting it up into 16 16-bit
numbers we can, using modulo to wrap around the list, select 16
characters. Voila! By using the hash as a pseudo random number
generator we now have a 16 character long password.
There is a very slight bias towards the first 16 characters, read
the details about that in the blogpost.

I have made some rather large changes to this functionality that
I will try to walk through piece by piece. The result improves
performance with regard to the size of the numbers created by the
hash, removes the character selection bias, and finally it includes
the possibility to put restriction on minimum and maximum passwords
by working on a variable length alphabet.

### Changing How Character Selection Works
In the original module 16 16-bit numbers are calculated from the hash from which characters are then chosen from a predefined alphabet, as explained above. However the length of the alphabet was only 36 characters long and could might as well be chosen by a 4 bit number, that gives a max alphabet length of 64 and an equally large password.
However, when putting restrictions on the number of specific character types, it calls for certain complexity as it has an effect on the alphabet of characters to choose from. The size of the alphabet really decides how many bits are necessary to read from the hash.

Let's start by looking at how (pseudo random) numbers are drawn from the hash

    function getPrn(size) {
        // Do this to emulate a stream cipher.
        if(prnString.length < size) {
            prnString += self.hash(
                self.hash(
                    self.hash(usedPrn, passwordCandidate),
                    prnString),
                size
            );
        }
        var hexa = prnString.substring(0, size)
        var n = parseInt(hexa, 16);
        prnString = prnString.substring(size);
        usedPrn += hexa;
        return n;
    }

`getPrn` reads a number of characters from `prnString` which is the original hash. It is parsed as a hexadecimal and returned as a number. In case the password generation algorithm requires more numbers than available in the hash, a new one is generated using a combination of the used hash as well as the generated password.

The pseudo random number is used like this

    do {
        idx = getPrn(prnSize);
    } while(idx >= maxPrnVal - (maxPrnVal % divisor));

`prnSize` holds the smallest integer where _n*16 >= length of the alphabet_.
`maxPrnVal = prnSize * 16`. The guard makes sure that numbers where there is a selection bias is simply discarded.
The `idx` value is then used to select a character from the alphabet. How this is generated and used will be covered next.

### Add character selection restrictions
We distinguish between 4 character types capital letters ([A-Z]), minuscule letters ([a-z]), numeric characters ([0-9]), and special characters ( !"#$%&'()*+,-./:;<=>?@[]^_\`{|}~).
Each of the character types are configured at object instantiation like this

    self.numeric = config.numeric;
    if(self.numeric !== false) {
        var alpha = '';
        var cfg = config.numeric || {};
        for(var cc = 48; cc < 58; cc++) {
            alpha += String.fromCharCode(cc);
        }
        self.rules.numeric = {
            'min': cfg.min || 1,
            'max': cfg.max || 0,
            'alphabet': cfg.alphabet || alpha
        };
    }

The configuration of the character type has 3 options, `min`, `max`, and `alphabet`. Each one has a default attribute of `0`, `1`, and `0123456789` respectively. (The default value of alphabet of course changes with the type).
The configuration is then added to a an object `rules` which will be used when generating the password.

When building the password, after generating the hash, an initial alphabet based on the configuration parameters are built.

    self.generate_alphabet = function(rules) {
        var alpha = ''
        if(self.alphabet) {
            alpha = self.alphabet;
        } else {
            for(var r in rules) {
                alpha += rules[r].alphabet
            }
        }

This code is straight forward and simply builds a long string concatenating all of the character type alphabets. The next character for the password is chosen from this alphabet as described in the previous section.

The important (and interesting) part happens when a character has been selected. First the type of the character `charType` is detected for which we execute the following.

    charType = charIs(nextChar);
    var typeMetadata = metadata[charType]
    if(typeMetadata.max >= typeMetadata.min &&
       typeMetadata.count >= typeMetadata.max) {
        delete metadata[charType];
        alphabet = self.generate_alphabet(metadata);
        divisor = alphabet.length;
        prnSize = 0;
        while(Math.pow(16, prnSize) < divisor) prnSize++;
        maxPrnVal = Math.pow(16, prnSize);
        continue;
    } else {
        metadata[charType].count++;
    }


What happens is, that if a certain character type has been detected `max` times, the type is removed altogether from the alphabet. Furthermore the variables used to decide the number of bits to use when creating the next pseudo random number is recalulcated based on the new alphabet.
Otherwise the `charType` is simply recorded as being used.
