### The vision
Now, let's take a look at the design changes to the plugin.
The library and project is still a work in progress (see
https://rlindsgaard.github.io/2016/01/29/rndphrase-roadmap).
However all relevant design changes has been decided upon, so
I will start by drawing an image of how it will look and feel
when complete.

Personally, I had three major issues regarding the original RndPhrase
browser plugin. The most severe was that the password is entered
directly into the field on the form on the website, which allows
for a malicious webpage to obtain the password. As an example,
github.com sends every key entered in the password change form
as an ajax request in order to decide how secure it is.
Because of the master seed, this is not fatal, but still an
issue. The solution is to issue a prompt which is not accessible
from the DOM of the website.

The second issue I have is the fact that the seed is stored permanently
in the browser as a configuration option. As a result, a person
with access to ones browser would be able to obtain the seed.
Instead,

Therefore, the most important change is to enter the password
With the old plugin implementation, I had three major issues. The most severe one was that which I mentioned in the introduction, that it is possible for a malicious site to sniff the password as it is entered into the DOM. The second issue is that the seed is stored stored in the browser as a preference option. This is not the worst place ever, especially as the password is hashed before it is saved. However, if anyone were to "borrow" my browser, they will have access to the seed without having to knowing it. Instead I want, at least an option, to store the seed only for the current session.

Finally, I find it annoying that the domain part needs to resolve to an actual domain. I may want to RndPhrase for things that does not have a fully qualified domain name, and I may also want to enter specific information as a path part. This will come in handy for instance when having several users on one domain sharing seed and password.

### Improved Plugin Design
Now, let's take a look at the design changes to the plugin. With the old plugin implementation, I had three major issues. The most severe one was that which I mentioned in the introduction, that it is possible for a malicious site to sniff the password as it is entered into the DOM. The second issue is that the seed is stored stored in the browser as a preference option. This is not the worst place ever, especially as the password is hashed before it is saved. However, if anyone were to "borrow" my browser, they will have access to the seed without having to knowing it. Instead I want, at least an option, to store the seed only for the current session.
Finally, I find it annoying that the domain part needs to resolve to an actual domain. I may want to RndPhrase for things that does not have a fully qualified domain name, and I may also want to enter specific information as a path part. This will come in handy for instance when having several users on one domain sharing seed and password.
