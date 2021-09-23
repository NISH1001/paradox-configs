#!/usr/bin/env python3

import sys


def main():
    if len(sys.argv) < 2:
        return
    args = sys.argv[1:]
    print(" ".join(args))


if __name__ == "__main__":
    main()
