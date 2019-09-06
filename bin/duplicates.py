#/usr/bin/env python3
import os
import sys

if len(sys.argv) != 3:
    sys.exit("Usage: duplicates.py <dir> <extension>\nExample: duplicates.py ./ .c")

lookup = {}

for subdir, dirs, files in os.walk(sys.argv[1]):
    for file in files:
        if not file.endswith(sys.argv[2]):
            continue
        filepath = subdir + os.sep + file
        if file not in lookup:
            lookup[file] = [filepath]
        else:
            lookup[file].append(filepath)

for name, paths in lookup.items():
    if len(paths) > 1:
        paths = '\n\t' + '\n\t'.join(paths) + '\n\t'
        print(f"{name} : {paths}")
