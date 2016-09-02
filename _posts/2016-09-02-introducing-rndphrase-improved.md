---
title: Introducing RndPhrase Improved
layout: post
---

This is a blogpost to accompany the alpha release of [RndPhrase.js](https://github.com/RndPhrase/RndPhrase.js),
and covers the improved password generation algorithm as well
as design choices/trade-offs made during development.

The original implemenation is described in
[Johan's blogpost](http://brinchj.blogspot.dk/2010/02/rndphrase.html)
which covers some of the basic ideas and math behind this method.
For basic design and security discussion please refer to
[PwdHash](http://crypto.stanford.edu/PwdHash/pwdhash.pdf) as the design is
identical (it is not a long read) with the exception of a few additions.

Library sourcecode is available at [github](https://github.com/RndPhrase/RndPhrase.js). PoC usage at [RndPhrase.github.io](https://github.com/RndPhrase/RndPhrase.github.io).

## RndPhrase Improved TL;DR
A bulletpoint list of added features:

* Modular library code with a well defined API with support for
  overriding methods.
* Replaced underlying hashing algorithm to PBKDF2.
* Asynchronous password generation.
* Extended default alphabet and functionality to add character
  types.
* Functionality to add character type constraints.

## New features

### Modular Library Code
Initially there was an incentive to make RndPhrase modular in order to
ease browser integration.

The library now supports being imported as an AMD module, a node
module and as a browser extension with e.g. require.js.

### Replaced Hash Algorithm
As the major browsers all impement the Web Crypto API which support
different hashing methods, I found it unnecessary to use a homegrown
implementation of cubehash. Using a built-in library means less
code and therefore also fewer bugs. Furthermore it is also one
fewer dependency.

Instead PBKDF2 has been chosen as the standard algorithm.
It takes a count of how many iterations of the hash to perform
which goes well with how the `version` parameter works.

Fear not if you want to use another implementation, the API makes
it possible to overwrite the hashing algorithm through `dprngFunction`.
The default looks like this, and distinguishes between running
the code from nodejs (as node has a Crypto library which is W3C
standardized) and in a browser:

    function dprngFunction(password, salt, rounds, size, callback) {
        if (typeof exports === 'object') {
            var crypto = require('crypto');

            crypto.pbkdf2(password, salt, rounds, size,
                function(err, key) {
                    callback(new Uint8Array(key));
                });
        } else {
            // Adapted from https://developers.google.com/web/updates/2012/06/How-to-convert-ArrayBuffer-to-and-from-String
            // Be warned, this assumes utf-8 input
            var str2ab = function(str) {
                var buf = new ArrayBuffer(str.length);
                var bufView = new Uint8Array(buf);
                for (var i = 0; i < str.length; i += 1) {
                    bufView[i] = str.charCodeAt(i);
                }
                return buf;
            };

            window.crypto.subtle.importKey(
                'raw',
                str2ab(password),
                {'name': 'PBKDF2'},
                false,
                ['deriveBits']).then(function(key) {
                    window.crypto.subtle.deriveBits(
                    {
                        'name': 'PBKDF2',
                        'salt': str2ab(salt),
                        iterations: rounds,
                        'hash': {'name': 'SHA-1'}
                    },
                    key,
                    size*8
                ).then(function(bits) {
                    callback(new Uint8Array(bits));
                });
            });
        }
    }


### Asynchronous Password Generation
As password generation can potentially take a long time depending
on the algorithm and rounds, having asynchronous code is useful
when it comes to developing browser extensions as especially the
Chrome and Firefox browsers uses callback functionality between
the DOM and module code.

Having the password generating code being asynchronous is not a
must, but as  the methods in the W3C Crypto API works asynchronously,
the choice of making the rest of the code asynchronous was a no
brainer.
The only real difference to the old code is that when invoking
`generatePassword` (previously just `generate`) one has to supply
a callback method.

    var r = new RndPhrase();
    r.generatePassword(function(password) {
        console.log(password);
    });


### Extended Alphabet and Constraints
It is now possible to define character types and add constraints
for these. Per default there are 4 character types called
`capital`, `minuscule`, `numeric`, and `special`.
The default configuration looks like this:

    {
        "capital": {
            "min": 1,
            "max": 0,
            "alphabet": "ABCDEFGHIJKLMONPQRSTUVWXYZ"
        },
        "minuscule": {
            "min": 1,
            "max": 0,
            "alphabet": "abcdefghijklmnopqrstuvwxyz|"
        },
        "numeric": {
            "min": 1,
            "max": 0,
            "alphabet": "1234567890"
        },
        "special": {
            "min": 1,
            "max": 0,
            "alphabet": " !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
        }
    }

Each constraint defines a character type which is defined by
the characters in `alphabet`. The `min` and `max` value are used
to constrain the number of characters from a character type in
the generated password.


## Improved Password Generating Algorithm
When `generatePassword` is invoked it first collects the current
configuration of the RndPhrase object.
It then calls the `dprngFunction` in order to create a hash of
the password. On completion, a private method `doGeneratePassword`
is invoked as callback with a byte array as input with the generated
hash of the seed, password and uri.

`doGeneratePassword` initialises by generating a set of currently
active constraints and use it to generate a combined alphabet to
select from (order matters).

    var current_constraints = initCurrentConstraints(constraints);
    var alphabet = generateAlphabet(current_constraints);
    var next_char = getNextChar(alphabet);

The byte array is traversed and for each byte in the array a
character in the alphabet string is chosen

    function getNextChar(alphabet) {
        var dprn,
            divisor = alphabet.length,
            maxPrnVal = Math.pow(16);
        do {
            //This is ugly, but the alternative is worse.
            dprn = bytes[0];
            bytes = bytes.slice(1);
        } while(dprn >= maxPrnVal - (maxPrnVal % divisor));

        if(isNaN(dprn)) {
            return undefined;
        }

        return alphabet[dprn % divisor];
    }

The character type of the selected character is registered and
in the case that a maximum number of a charater type is selected
it is removed as an active constraint and the alphabet, to select
characters from, is re-computed.

    while(next_char) {
        char_type = charType(next_char, current_constraints);
        password += next_char;
        current_constraints[char_type].count += 1;

        // Regenerate alphabet if necessary
        var constraint = current_constraints[char_type];
        if(constraint.max >= constraint.min &&
           constraint.count >= constraint.max) {
            delete current_constraints[char_type];
            alphabet = generateAlphabet(current_constraints);
        }
        next_char = getNextChar(alphabet);
    }

Finally, when the byte array has been traversed the password
is validated, if it does not pass validation the entire process
is re-iterated with one more round of hashing.

    if(validate(password, constraints)) {
        callback(password);
    } else {
        instance.version += 1;
        instance.generatePassword(function(pw) {
            callback(pw);
        });
    }

## Design Discussion
### Alphabet Abstraction
So, why are we even using alphabets in the first place? Ideally we only need
to produce a large hash and in itself it would contain enough entropy to make
the password secure. The problem is however that the webservice industry are
notorius when it comes to constraining how passwords should look, requiring
the use of capital and minuscule letters, numbers and special characters.
The solution is therefore to add the extra layer, defining the alphabet (as
well as minimum occurences etc.)

A benefit of this approach is that in order to remove selection bias from the
final password construction some bits are thrown away - in this case, it is
even impossible to reconstruct the hash which was used to generate the password
making it even harder to construct a hash collision attack.

### Modularity and wrappers
The library is designed to be self-containing as much as possible, at the same
time is should be configurable in the sense that it should support usecases
not constricting to generating personal passwords. The solution was to add
object arguments. Furthermore the actual hashing computation is modular as well.
To use another hashing algorithm a wrapper method needs to be supplied making
the actual computation and returning the result.

## Conclusion
So, this is it. A lot of these design choices have a benefit with
regard to added security in one way or the other. The argument for
that I will save for a later post covering the security and promises
of the design as a whole, and which weaknesses it has.

There will be at least one more alpha version comming up with minor
changes. It will break backwards compatability. For latest release
please follow [rndphrase.github.io](https://rndphrase.github.io).
[rndphra.se](https://rndphra.se) will be stable at 0.9.5 until
further notice.
