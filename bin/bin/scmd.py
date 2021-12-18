#!/usr/bin/env python3

import glob
import pydoc

import os
import sys
import subprocess


LOGS_DIR = os.getenv("LOGS_DIR", os.path.expanduser("~/.bash-logs/logs/"))
CMD_SPLITTER = os.getenv("CMD_SPLITTER", 2)


def main():
    assert os.path.exists(LOGS_DIR)

    args = sys.argv[1:]
    if not args:
        sys.exit(0)

    files = glob.glob(os.path.join(LOGS_DIR, "*.log"))
    files.sort(key=os.path.getmtime)
    nfiles = len(files)
    print(f"{nfiles} files")

    if not nfiles:
        sys.exit(0)

    _loader = lambda x: open(x).readlines()
    logs = map(lambda x: [l.strip() for l in open(x).readlines()], files)
    logs = list(filter(lambda x: len(x) > 0, logs))
    nlogs = len(logs)
    print(f"{nlogs} non-empty logs")
    print("-" * 10)

    matches = []
    for log in logs:
        for line in log:
            m = all([arg in line for arg in args])
            cmd = " ".join(line.split()[CMD_SPLITTER:])
            if m and cmd not in matches:
                matches.append(cmd)

    print(f"{len(matches)} matches")
    res = "\n".join(matches)
    pydoc.pager(res)


if __name__ == "__main__":
    main()
