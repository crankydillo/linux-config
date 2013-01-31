#!/usr/bin/python

from subprocess import call
import sys
import pycurl
 
def handle(buf):
    print buf

def call_di_service(resource):
  c = pycurl.Curl();
  c.setopt(c.URL, 'http://server/resource')
  c.setopt(pycurl.HTTPAUTH, pycurl.HTTPAUTH_DIGEST) 
  c.setopt(pycurl.USERPWD, "user:pass") 
  c.setopt(pycurl.WRITEFUNCTION, handle)
  c.perform()

for i in range(2):
  call_di_service(sys.argv[1])
