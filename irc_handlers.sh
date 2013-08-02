#!/bin/bash

# Associative arrays defining which commands to call depending
# on a regex-based match of the IRC event with egrep.
# ..._REGEX is an array of regular expressions to match against.
# ..._HANDLER is an array of commands to call if regex with same
#             index is matched
#
# For join events, we match against the nickname that joined.
JOIN_REGEX=("")
JOIN_HANDLER=("join_default")

# For message events, we match against the message that was said.
MSG_REGEX=("" '^\+')
MSG_HANDLER=("msg_default" "msg_command")


#######################################################################

MICROBLOG_UPDATE=./microblog.py
MICROBLOG_MAXLEN=140

join_default () {
  local NICK="$1"
}

msg_default () {
  local NICK="$1"
  local MSG="$2"
}

msg_command () {
  local NICK="$1"
  local MSG="$2"

  local CMDCH=${MSG:0:1}
  local CMD=$(cut -c 2- <<<"$MSG" | cut -d' ' -f1)
  local ARGS=$(cut -d' ' -f 2- <<<"$MSG")

  case $CMD in
    cookie)
      echo 'nomnomnomcrunch!! \o/'
      ;;

    moo|fart|o\<)
      if [ ${#ARGS} -gt $MICROBLOG_MAXLEN ]; then
        echo You message is too long, "$NICK". Maximum $MICROBLOG_MAXLEN but you typed ${#ARGS}.
      else
        $MICROBLOG_UPDATE "$ARGS"
      fi
      ;;

    \<3)
      local TID=$(cut -d' ' -f 1 <<<"$ARGS")
      $MICROBLOG_UPDATE RT $TID
      ;;

    re)
      local TID=$(cut -d' ' -f 1 <<<"$ARGS")
      local TEXT="$(cut -d' ' -f 2- <<<"$ARGS")"
      if [ ${#TEXT} -gt $MICROBLOG_MAXLEN ]; then
        echo "Message too long, $NICK". Maximum $MICROBLOG_MAXLEN but you typed ${#TEXT}.
      else
        $MICROBLOG_UPDATE RP $TID "$TEXT"
      fi
      ;;

    ur1)
      local URL=$(cut -d' ' -f1 <<<"$ARGS")
      curl -so - --data-urlencode longurl="$URL" --data-urlencode submit='Make it an ur1!' http://ur1.ca \
           | grep 'p class="success"' | html2text -nobs | head -n 1
      ;;

    help)
      echo 'cookie moo fart o< ur1'
      ;;

    *)
      echo 'wat?'
      ;;
  esac
}
