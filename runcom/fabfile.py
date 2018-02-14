import fabric
from fabric.api import local, run, lcd, cd, env

import os
from os import path
from os.path import exists as file_exists

import glob
import os
from subprocess import check_call
import sys
import json
import re
import requests


PWD = path.dirname(__file__)
VENV_DIR = path.join(PWD, '.env')
DEV_ENV_DIR = path.join(PWD, '.denv')

# pylint: disable=E1601

def travis_status():
    git_dirs = local("find . -name 'boss*' -maxdepth 1 -type d -print ", capture=True)
    git_dirs = git_dirs.split("\n")
    # import pdb
    # pdb.set_trace()

    for d in git_dirs:
        with lcd(d):
            # print d
            if file_exists("{}/{}".format(d,".git")):
                print "{}:".format(d)
                status = local("travis status")
                print status
