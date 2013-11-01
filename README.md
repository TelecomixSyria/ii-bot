# Telecomix Syria's ii-bot

Yeah, lovely ii from irc.wnh.me/6697 (SSL) #dn, open for hacks for fun and non-profit!

## Prerequisites
A couple of common system packages are required: `ii`, `curl`, `html2text` and some others that will most likely be installed by default on your distro. Make sure `bash` is installed, at least version 4.

It'll probably be much better if you already know how `ii` works (it's dead simple).

There are Python packages needed to for the microblogging support, see _import_ statements in `microblog.py`.

## Configure
Edit `bot.sh` to setup IRC server and channels settings.

Since `ii` does not know SSL, you'll need something like `socat` if you want to connect using _SSL_. You may use something like:

    socat TCP4-LISTEN:8888,bind=127.0.0.1,fork,reuseaddr OPENSSL:irc.wnh.me:6697

If `socat` does not trust the remote SSL certificate, you should use the parameter `cafile` and provide the path to the trusted root certificate. In the worst case you can append `verify=0` to the `OPENSSL` command to by pass the SSL verification. See the manpage `socat(1)`.

For microblogging (StatusNet, Twitter), you'll need to configure the proper credentials in `microblog_secrets.py` (there is an example file in `microblog_secrets.py.example`) and probably change the StatusNet domain setting in `microblog.py` (if the code was clean it would not be hardcoded).

Change `{JOIN,MSG}_{REGEX,HANDLER}` arrays in `irc_handlers.sh` to customize nicks and messages your bot recognizes and which functions are called depending on what happens on IRC. In the same file, you can create and modify existing handlers: they define the reaction of your bot.

## Run
The first thing to do is to start the bot: `./bot.sh`. If all goes well, your bot should join the channels you configured.

Then the rest of the scripts actually make your bot do something. Up to you to run them in the background or in a `screen` or `tmux`.

- `./microblog.sh >/path/to/#channel/in` will write StatusNet and Twitter timelines and mentions onto IRC
- `tail -n0 -f /path/to/#channel/out | ./process_irc.sh >/path/to/#channel/in` will process the channel activity and write standard output of the handlers to the channel.

## Hack
The most simple is to add handlers to `irc_handlers.sh` to elaborate the bot's behavior and make it do more things.

Corrections and bugfixes on existing code will probably be merged. New features (like bot functionnalities) will only be merged if they are relevant in the case of ii-bot running on wnh.me. This is of course totally subject to random and arbitrary changes. But you're free to clone the repo and do whatever you like with it anyway.
