#!/usr/bin/env python3
import sys

# Read a file of nginx redirects, print any exact duplicates
# (Matching only the first part, the from, not the destination)

redirects = {}

with open(sys.argv[1], "r") as f:
    for line in f.readlines():
        line = line.strip()
        if not line.startswith("rewrite "):
            print("Skipping non-rewrite line: " + line)
            continue
        rule = line[len("rewrite "):]
        key = rule.split()[0]
        value = rule.split()[1:]
        if key in redirects:
            print("Duplicate redirect: " + key)
        redirects[key] = value
