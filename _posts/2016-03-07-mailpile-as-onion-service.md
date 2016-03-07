---
layout: post
category : mailpile
title: Mailpile as an Onion Service
tags : [mailpile, tor]
---

This post features how to configure and access your Mailpile
installation using a stealth onion service.

There are two benefits of this approach. First, you don't need
to perform any routing setup as holepunching is built-in to this
solution.
Second, using a stealth onion service also gives you an extra
layer of security, as it is not advertised as regular services,
and you are the only one that is actually able to connect to it.

## Prepare the system
I am going to do the setup on a Debian based system. I assume
that you have already managed to get mailpile running on your
system at port 33411 and have done the necessary configuration.

    sudo apt-get install tor nginx


## Configure nginx
Routing it through nginx is mainly for getting some nice access
and error logs.

Put this into `/etc/nginx/sites-enabled/mailpile`

    server {
      listen 33410;
      server_name _;

      location / {
        access_log /var/log/nginx/mailpile_access.log;
        error_log /var/log/nginx/mailpile_error.log info;

        proxy_pass http://127.0.0.1:33411;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      }
    }

Restart nginx `sudo service nginx restart`. You should now be
able to access the hidden service from the world on port 33410.
Note: You should probably configure a firewall to deny

## Configure tor
Edit your `/etc/tor/torrc` file and add the following

    HiddenServiceDir /var/lib/tor/mailpile/
    HiddenServicePort 80 127.0.0.1:33410
    HiddenServiceAuthorizeClient stealth mailpile

There is a section for hidden services so you probably want to
add it there.

Restart tor

    sudo service tor restart

## Configure TBB
After restarting tor, a new onion service was created. Read the
contents of the file `/var/lib/tor/mailpile/hostname` (hint, you
need root)
The format for each line is

    <onion-address> <secret-password> # client: mailpile

Locate the torrc file in your browser bundle (it is probably located
at `Browser/TorBrowser/Data/Tor/torrc` and add a line

    HidServAuth <onion-address> <secret-password>

Restart your Tor browser and you should be able to access your
mailpile installation. (Note: You might need to wait 15 minutes
as stealth hidden takes a bit longer to initialise in the network).
