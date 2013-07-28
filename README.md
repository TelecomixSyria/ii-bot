# Telecomix Syria's ii-bot

Yeah, lovely ii from irc.wnh.me/6697 (SSL) #dn, open for hacks for fun and non-profit!

## Prerequisistes
A couple of common system packages are required: `ii`, `curl`, `html2text` and some others that will most likely be installed by default on your distro. Make sure `bash` is installed, at least version 4.

There are Python packages needed to for the microblogging support, see _import_ statements in `microblog.py`.

## Configure
Edit `bot.sh` to setup IRC server and channels settings.

Since `ii` does not know SSL, you'll need something like `socat` if you want to connect using _SSL_. You may use something like:

    socat TCP4-LISTEN:127.0.0.1:8888,fork,reuseaddr OPENSSL:irc.wnh.me:6697

For microblogging (StatusNet, Twitter), you'll need to configure the proper credentials in `microblog_secrets.py` and probably change the StatusNet domain setting in `microblog.py` (if the code was clean it would not be hardcoded).

Change `{JOIN,MSG}_{REGEX,HANDLER}` variables in `process_irc.sh` to customize nicks and messages your bot recognizes and which functions are called depending on what is matched. Then, create your own or modify exiting handlers in `irc_handlers.sh`.

## Run
The first thing to do is to start the bot: `./bot.sh`. If all goes well, your bot should join the channels you configured.

Then the rest of the scripts actually make your bot do something. Up to you to run them in the background or in a `screen` or `tmux`.

- `./microblog.sh >/path/to/#channel/in` will write StatusNet and Twitter timelines and mentions onto IRC
- `tail -n0 -f /path/to/#channel/out | ./process_irc.sh >/path/to/#channel/in` will process the channel activity and write standard output of the handlers to the channel.

## Hack
The most simple is to add handlers to `irc_handlers.sh` to elaborate the bot's behavior and make it do more things.

Corrections and bugfixes on existing code will probably be merged. New features (like bot functionnalities) will only be merged if they are relevant in the case of ii-bot running on wnh.me. This is of course totally subject to random and arbitrary changes. But you're free to clone the repo and do whatever you like with it anyway.
