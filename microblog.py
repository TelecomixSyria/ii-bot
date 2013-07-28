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
  newstatus = sys.argv[1]

  ret_twitter = 'OK'
  ret_statusnet = 'OK'

  try:
    sn.statuses.update(status=newstatus)
  except:
    ret_statusnet = 'fail'

  try:
    t.statuses.update(status=newstatus)
  except:
    ret_twitter = 'fail'

  print u"StatusNet: %s - Twitter: %s" %(ret_statusnet, ret_twitter)

else:
  tl = t.statuses.home_timeline() + t.statuses.mentions_timeline() + sn.statuses.home_timeline() + sn.statuses.mentions()

  for status in tl:
    print u"%s: %s - %d" % (status['user']['screen_name'], parser.unescape(status['text']), status['id'])

