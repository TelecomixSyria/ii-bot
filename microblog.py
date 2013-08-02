#!/usr/bin/env python

# -*- coding: utf-8 -*-

# This Python script uses the Twitter library to read
# status updates and public our updates.
# Make sur you have the good requirement installed.
#
# Credentials etc. are attributes read from microblog_secrets.py:
# ACCESS_KEY, ACCESS_SECRET, CONSUMER_KEY, CONSUMER_SECRET for OAuth
# USERNAME, PASSWORD for basic auth

from twitter import *
import HTMLParser
import unicodedata
import sys
import locale
import codecs
import microblog_secrets

sys.stdout = codecs.getwriter('utf8')(sys.stdout)

parser = HTMLParser.HTMLParser()

t = Twitter (secure=True, auth=OAuth(microblog_secrets.ACCESS_KEY, microblog_secrets.ACCESS_SECRET, microblog_secrets.CONSUMER_KEY, microblog_secrets.CONSUMER_SECRET))
sn = Twitter(secure=True, domain='status.homecomputing.fr/api', auth=UserPassAuth(microblog_secrets.USERNAME, microblog_secrets.PASSWORD))

if len(sys.argv) >= 2:
  ret_twitter = 'OK'
  ret_statusnet = 'OK'

  if len(sys.argv) == 2:
    newstatus=sys.argv[1]

    try:
      sn.statuses.update(status=newstatus)
    except:
      ret_statusnet = 'fail'

    try:
      t.statuses.update(status=newstatus)
    except:
      ret_twitter = 'fail'

  elif len(sys.argv) >= 3:
    command=sys.argv[1]
    argument=sys.argv[2]

    if command == 'RT' and len(argument) < 18:
      ret_twitter = 'N/A'
      try:
        sn.statuses.retweet (argument)
      except:
        ret_statusnet = 'fail'

    elif command == 'RT' and len(argument) == 18:
      ret_statusnet = 'N/A'
      try:
        t.statuses.retweet (argument)
      except:
        ret_twitter = 'fail'

    elif command == 'RP' and len(sys.argv) == 4:
      argmsg = sys.argv[3]
      params = {'status': argmsg, 'in_reply_to_status_id': argument}
      if len(argument) < 18
        ret_twitter = 'N/A'
        try:
          sn.statuses.update (**params)
        except:
          ret_statusnet = 'fail'
      elif len(argument) == 18
        ret_statusnet = 'N/A'
        try:
          t.statuses.update (**params)
        except:
          ret_twitter = 'fail'

  print u"StatusNet: %s - Twitter: %s" %(ret_statusnet, ret_twitter)

else:
  tl = t.statuses.home_timeline() + t.statuses.mentions_timeline() + sn.statuses.home_timeline() + sn.statuses.mentions()

  for status in tl:
    print u"%s: %s - %d" % (status['user']['screen_name'], parser.unescape(status['text']), status['id'])

