#!/usr/bin/env python3

import sys

from datetime import datetime as dt
import parsedatetime as pdt


def suffix(d):
    return "th" if 11 <= d <= 13 else {1: "st", 2: "nd", 3: "rd"}.get(d % 10, "th")


def custom_strftime(format, t):
    return t.strftime(format).replace("{S}", str(t.day) + suffix(t.day))


def main():
    args = "today"
    if len(sys.argv) > 1:
        args = " ".join(sys.argv[1:])
    cal = pdt.Calendar()
    time_struct, parse_status = cal.parse(args)
    res = dt(*time_struct[:6])
    res = custom_strftime("%B {S}, %Y", res)
    res = f"[[{res}]]"
    print(res)


if __name__ == "__main__":
    main()
