#!/bin/bash
# This script should be fed (stdin) with ii's outfiles (channels) (use tail -f)
# This script is just here to recognize joins and messages, match them against
# patterns that you want and call functions that you specify (see irc_handlers.sh)
#
# You do whatever you want with the input, but generally in the end you'll want
# to output something typically to an 'in' pipe file of the ii IRC client.
#
# So you can do something like:
# tail -n 0 -f ~/ii-data/irc.freenode.org/#blip/out | ./process_irc.sh >~/ii-data/irc.freenode.org/#blip/in
# for a bot acting on irc.freenode.org:#blip.
#
# /!\ bash >= 4 required (using associative arrays) /!\

# Regex patterns to recognize ii's output - probably don't need any change
DATE_TIME='[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}'
EGREP_JOIN="^$DATE_TIME"' -!-.*has joined.*'
EGREP_MSG="^$DATE_TIME <"

# Regex patterns (for sed) to fetch nicknames and messages from grep'd ii output lines.
# Probably don't need to be changed either.
SED_JOIN_NICK='s/'"^$DATE_TIME"' -!- ([^ \\(\\)]*).*/\1/'
SED_MSG_NICK='s/'"^$DATE_TIME"' <([^ ]*)>.*/\1/'
SED_MSG_MSG='s/'"^$DATE_TIME"' <[^ ]*> (.*)/\1/'

# In the following shell script you should define your handling functions
# and which match should trigger them.
. irc_handlers.sh

handle_join () {
  NICK="$1"

  for ID in ${!JOIN_REGEX[@]}; do
    REGEX=${JOIN_REGEX["$ID"]}
    CALL=${JOIN_HANDLER["$ID"]}
    if egrep -- "$REGEX" <<<"$NICK" >/dev/null; then
      $CALL "$NICK"
    fi
  done
}

handle_message () {
  NICK="$1"
  MSG="$2"

  for ID in ${!MSG_REGEX[@]}; do
    REGEX=${MSG_REGEX["$ID"]}
    CALL=${MSG_HANDLER["$ID"]}
    if egrep -- "$REGEX" <<<"$MSG" >/dev/null; then
      $CALL "$NICK" "$MSG"
    fi
  done
}

while read -r LINE;
do
  if egrep -- "$EGREP_JOIN" <<<"$LINE" >/dev/null; then
    NICK=$(sed -r "$SED_JOIN_NICK" <<<"$LINE")
    handle_join "$NICK"
  elif egrep -- "$EGREP_MSG" <<<"$LINE" >/dev/null; then
    NICK=$(sed -r "$SED_MSG_NICK" <<<"$LINE")
    MSG=$(sed -r "$SED_MSG_MSG" <<<"$LINE")
    handle_message "$NICK" "$MSG"
  fi
done
