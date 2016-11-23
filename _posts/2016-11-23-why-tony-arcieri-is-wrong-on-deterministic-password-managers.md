---
title: Why Tony Arcieri is Wrong on Deterministic Password Managers
layout: post
category: rndphrase
---

This is a response blogpost to Tony Arcieri's recent blogpost
[4 fatal flaws in deterministic password managers](https://tonyarcieri.com/4-fatal-flaws-in-deterministic-password-managers).
Please read that for reference. I provide my own take on the TL;DR
on each of his points, but that is just my
own subjective analysis.


# Deterministic password generators cannot accommodate varying password policies without keeping state

TL;DR: You can't have sync-free password managers, the world is
simply too stupid. Tweaks are a possibility, but then you're
not sync-free anymore anyway.

Correct. You want security, you compromise with usability. Not
really anything different from using offline password managers.

Arcieri writes he would argue why storing tweaks are not superior
to storing the entire database. Personally, I never saw an argument
for that anywhere. (Mr. Arcieri, if you read this, please elaborate).

Storing tweaks are only pieces to the password puzzle. If they
get compromised, it would be maybe easier to obtain the master
password, but it certainly beats having all passwords within a
single database file. It's a having all your eggs in one basket
thing.

And, really. How often do you really need to sync your password
databases? This is a usability issue, not a security issue, and
it is not inherent to deterministic password generators alone.


# Deterministic password generators cannot handle revocation of exposed passwords without keeping state
TL;DR: You need some sort of state for storing a "revoked" password
so the deterministic process knows not to use it.

Same arguments as above applies.

The size is not the issue. The liability of having the data floating
around on a harddrive or online is. As I will argue later.


# Deterministic password managers can’t store existing secrets
TL;DR: You can't store things like credit cards or password hints
with a deterministic password manager.

Well, no. But this is not within the problem domain of deterministic
password managers. Let's stick to arguing what we are actually
trying to solve.

The purpose of deterministic password managers are to easily generate
high-entropy passwords to use for authentication. I got my credit
card number on my credit card. I'm not going to place it anywhere
else besides when ordering things online.

With regard to other "known secrets" as password hints - use something
else. Perhaps a [GPG encrypted store](https://www.passwordstore.org/).


# Exposure of the master password alone exposes all of your site passwords
TL;DR: If the master password is compromised - you're screwed anyway.

Well, yes - if there's only one secret. You basically need two secrets.
A high-entropy master password (which you type in session wise, as
on computer or browser boot), and a site-/group-specific, not
necessarily as long and high entropy, password - which you type
in whenever you need your password.

And this is really here that deterministic password managers beat
normal password managers. Because you need to manually delete all
traces of your password database if your master password gets
compromised.
But what if your machine and database was already compromised?
How will you make sure all your data is no longer available?
This is quite easy to do if it was never stored in the first place.

Granted, a lot of the current implementations I have seen does
not huse these multiple secrets.
Given the very little scientific research on deterministic password
managers, I think it is way too early calling it snake oil.
It is not snake oil, but it is no magic bullet either.
