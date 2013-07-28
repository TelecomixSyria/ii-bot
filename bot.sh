#!/bin/bash
# Start ii and join channels.
#
# Note : to connect to SSL servers, you need a tool like
# socat that listens locally for cleartext and does the
# encrypted connection.

IRC_HOST="127.0.0.1"
IRC_PORT="8888"
IRC_NICK="ii"
IRC_CONNECTIONS="~/ii-data"
IRC_CHANS="#dn"

mkdir -p "$IRC_CONNECTIONS"


while true; do
  (sleep 20; echo $IRC_CHANS | xargs -n 1 echo /j >"$IRC_CONNECTIONS/$IRC_HOST/in") &
  ii \
        -i "$IRC_CONNECTIONS" \
        -s "$IRC_HOST" \
        -p "$IRC_PORT" \
        -n "$IRC_NICK" \
        -f "$IRC_NICK"
done
