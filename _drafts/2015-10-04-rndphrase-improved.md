---
title: Introducing RndPhrase Improved
layout: post
---

RndPhrase Improved is a library and toool based on
http://brinchj.blogspot.dk/2010/02/rndphrase.html|RndPhrase
originally created by Johan Brinch. It is a rewrite to a modular
structure, as well as improving on password generation algorithm.

I consider RndPhrase to be an invaluable tool, but there are
issues with the current code that needs to be adressed as I will
discuss in the following section. Johan no longer maintains it
himself and I have thereby taken it upon myself to do development
and maintenance, renaming it to RndPhrase Improved.

I will not cover the theory behind RndPhrase as Johan has already
done that on his blog. However, I will provide a short description
of the basic idea. Furthermore, I will cover design changes to
the structure, the improvements that have implemented,
and discuss the motivation behind these changes.

## An RndPhrase Primer
RndPhrase replaces the need for a password manager, as it makes
it possible to generate passwords instead of encrypting and storing
them, making it easy to steal them.

Using a hash of certain credentials (a master passphrase,
an easy to remember and type password, and a context) it generates
a long password considered "hard" by the community.
Furthermore, due to the context it becomes easy (transparent actually)
to use a different password for every domain it is used, even
though the basic password is reused.

The original RndPhrase implementation is a simple cross browser
plugin which listens on password fields and activates when an `@`
is typed as the first character. When the field's change event
triggers, it will generate a RndPhrase and replace the field
content with this value.
The master password is stored in the plugin configuration and
the context is gathered from the domain of the website where
the form is presented.

This is all fine and dandy and it does provide some nice benefits.

* I do not have the issue of data lying around waiting to be accidentally deleted or hacked.
* I can always generate my passwords, anywhere on any computer
(provided there is internet access or I have an offline copy).
* It is open source, and the code is small enough and simple enough
to read and understand.

However, there are also a series of shortcomings to the implementation.

* Passwords only consist of alphanumeric characters in lowercase.
* The password generation method is not reusable, and consists of
a mixture of javascript and make files.
* You can not configure password rules for a specific websites.
* There's some ad-hoc domain checking method from a hardcoded
file. Furthermore it only supports fully qualified top level
domain names ignoring sub-domains etc.
* The easy to remember password gets typed directly into the DOM
of the website which makes it possible to sniff by a malicious
site.
* It does not work well Websites that require you to change passwords periodically.


## Improving RndPhrase
### Making Code Modular
The project has been separated into several autonomous projects
on github.
The password generating code has been put into a stand alone library
module and can be used as a regular node module
(https://github.com/RndPhrase/RndPhrase.js.git).

There is a webbased user interface which uses the library module
and serves a page with a form to generate RndPhrases (https://rndphra.se).

Browser plugins will also be separated into one for each plugin
implementation. Currently there is only proof of concept code
for a Firefox plugin.

### Changing the PRNG
There are several reasons that motivates a change of the underlying
hash algorithm which is used to simulate the pseudo random number
generator. I call the product of a hash a deterministic random
number (DRN).

There is now a W3C standard for crypto libraries built into
the webbrowser, and there is no reason not to make use of that.
Cubehash is not part of the API, so the default hash algorithm
of RndPhrase Improved is instead PBKDF2 as it supports
providing rounds of computation, it is also used and known widely
and hopefully more trusted than some obscure algorithm.

However, the user (or developer) is not necessarily stuck with
this choice, as the algorithm can be changed by supplying a wrapper
function which imports requirements and takes three arguments
(message, salt, rounds).

### Event Based RndPhrase
Generating the hash with PBKDF2 requires some computation. It
makes sense to use the asynchronous version in order to not block
all threads whilst doing the computations.

 computing and
The design changes to the browser plugins, which are detailed in
full later, makes it beneficial to make the entire code work
asynchronously.
PBKDF2 works asynchronously, so it makes senIn order to not block the browser whilst computing the RndPhrase
the


## Better Password Generation
If you made it this far I congratulate you. You have arrived to
ground zero, this is here the shit gets real and we're gonna go
Computer Science on this mother. I really wanted to improve RndPhrase
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

## Work in progress
### Improved Plugin Design
Now, let's take a look at the design changes to the plugin. With the old plugin implementation, I had three major issues. The most severe one was that which I mentioned in the introduction, that it is possible for a malicious site to sniff the password as it is entered into the DOM. The second issue is that the seed is stored stored in the browser as a preference option. This is not the worst place ever, especially as the password is hashed before it is saved. However, if anyone were to "borrow" my browser, they will have access to the seed without having to knowing it. Instead I want, at least an option, to store the seed only for the current session.
Finally, I find it annoying that the domain part needs to resolve to an actual domain. I may want to RndPhrase for things that does not have a fully qualified domain name, and I may also want to enter specific information as a path part. This will come in handy for instance when having several users on one domain sharing seed and password.

###

## Security discussion
