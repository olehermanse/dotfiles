#!/usr/bin/env python3
"""
Script that is useful for renaming things in programming languages.

For example when you need to replace a string that is the name
of a class, file and directory, and is referenced within the contents
of files.

Usage:
python3 renamer.py . old_name new_name
"""

import os
import sys

def find(name, recursive=True, directories=False, files=True, extension=None, hidden=False):
    assert files or directories
    assert os.path.isdir(name)
    for root, subdirs, subfiles in os.walk(name):
        if directories:
            for dir in subdirs:
                if os.path.basename(dir).startswith('.') and not hidden:
                    continue
                if not extension or (extension and dir.endswith(extension)):
                    yield os.path.join(root, dir) + "/"
        if files:
            for file in subfiles:
                if os.path.basename(file).startswith('.') and not hidden:
                    continue
                if not extension or (extension and file.endswith(extension)):
                    yield os.path.join(root, file)
        if not recursive:
            return  # End iteration after looking through first (top) level

root, x, y = sys.argv[1], sys.argv[2], sys.argv[3]

for path in find(root, directories=True, files=False):
    if x in path:
        os.system(f"mv '{path}' '{path.replace(x, y)}'")
        print(f"Renamed '{path}' to '{path.replace(x, y)}'")

for path in find(root, directories=False, files=True):
    if x in path:
        os.system(f"mv '{path}' '{path.replace(x, y)}'")
        print(f"Renamed '{path}' to '{path.replace(x, y)}'")

for path in find(root, directories=False, files=True, extension=(".cf", ".org", ".json")):
    content = None
    with open(path, "r") as f:
        content = f.read()
    if x in content:
        with open(path, "w") as f:
            f.write(content.replace(x, y))
        print(f"Replaced '{x}' with '{y}' in '{path}'")
