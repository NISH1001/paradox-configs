#!/usr/bin/env python3

import sys,json, os
import subprocess

def get_cal():
    return subprocess.check_output(["nepaliconv", '-bs', '-u', '-f', 'y.m.d']).decode('utf-8').strip()

def main():
    print(get_cal())



if __name__=="__main__":
    main()

