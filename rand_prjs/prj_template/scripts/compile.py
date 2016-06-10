#!/usr/bin/python
import os
import re
from subprocess import call
from colorama import init, Fore, Back, Style
from termcolor import colored
import string
init()

def is_err(line) :
    return re.compile(r'\b({0})\b'.format(line), flags=re.IGNORECASE).search

os.chdir( os.path.dirname(os.path.dirname(os.path.abspath(__file__)))+'/mpd' )

with open('tempfile', 'w+') as tempfile :
    call(['vlog', '../qpd/*.v', '>', 'tempfile'], stdout=tempfile)

#call(["vlib", "work"])
#call(['vlog', '../src/*'])

with open('tempfile', 'r+') as tempfile :
    for line in tempfile: 
        if is_err('error')(line) : print(colored(line, 'red'))

