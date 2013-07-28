#!/bin/bash

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
  local CMD=$(cut -b 2- <<<"$MSG" | cut -d' ' -f1)
  local ARGS=$(cut -d' ' -f 2- <<<"$MSG")

  case $CMD in
    cookie)
      echo 'nomnomnomcrunch!! \o/'
      ;;

    moo|fart)
      if [ ${#ARGS} -gt $MICROBLOG_MAXLEN ]; then
        echo You message is too long, "$NICK". Maximum $MICROBLOG_MAXLEN but you typed ${#ARGS}.
      else
        $MICROBLOG_UPDATE "$ARGS"
      fi
      ;;

    ur1)
      local URL=$(cut -d' ' -f1 <<<"$ARGS")
      curl -so - --data-urlencode longurl="$URL" --data-urlencode submit='Make it an ur1!' http://ur1.ca \
           | grep 'p class="success"' | html2text -nobs | head -n 1
      ;;

    help)
      echo cookie moo fart ur1
      ;;

    *)
      echo 'wat?'
      ;;
  esac
}
