#!/usr/bin/python

import os
import shutil
import sys

from subprocess import call

work_dir = "tmp-arch"
uber_jar_name = "uber.jar"

def jars(dirname):
    files = os.listdir(dirname)
    return [os.path.join(dirname, f) for f in files if f.endswith(".jar")]

def explode(archive):
    call(["unzip", "-d", work_dir, archive])

lib_dir = "."
if (len(sys.argv) > 1):
    lib_dir = sys.argv[1]

for jar in jars(lib_dir):
    explode(jar)

os.chdir(work_dir)
call(["zip", "-r", uber_jar_name, ".", "-i", "*"])
try:
    shutil.move(uber_jar_name, "..")
except Exception:
    print(Exception)

os.chdir("..")
shutil.rmtree(work_dir)
