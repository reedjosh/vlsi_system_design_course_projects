#!/usr/bin/python
import os

def get_par(dir, num) :
    if (num > 0) : return get_par(os.path.dirname(dir), num-1)
    else : return dir

curr_dir = os.path.abspath(__file__)
print(curr_dir)
os.putenv('PRJ_DIR', get_par(curr_dir,2))
print(os.getenv('PRJ_DIR'))
