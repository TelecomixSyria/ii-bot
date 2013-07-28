#!/bin/bash
# Calls python script periodically to
# fetch timeline and mentions.
# Save hashes of already fetched messages
# in local DB to avoid duplicate displaying.

DB=./db.msg
FETCH=./microblog.py
INTERVAL=300

touch $DB

while true; do
  $FETCH | while read -r line; do
    HASH=$(echo "$line" | md5sum | awk {'print $1'})
    if ! grep $HASH "$DB" >/dev/null; then
      echo "$line"
      echo $HASH >>"$DB"
    fi
  done

  sleep $INTERVAL
done
