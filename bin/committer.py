#!/usr/bin/env python3
"""
Script for running a command and committing the results
"""

import os
import sys
import subprocess

url = os.getenv("URL")

assert url

history_1 = os.path.expanduser("~/.logs/history_1.log")

command = open(history_1, "r").read()[7:]

script = command.split(" ")[0]

print(command)
print(script)
print(url)

assert url.endswith(script)

os.system("git reset --hard HEAD")
os.system("git clean -fxd")
os.system("git clean -fXd")

print(f"Running command: {command}")
os.system(f"{command} > output.txt")
output = open("output.txt", "r").read()
os.system(f"rm output.txt")

os.system("git add -A")

title = output.split("\n")[0]
message = f"""{title}

Ran command:

```
{command}
```

With script from:

{url}

Output:

```
{output.strip()}
```
"""

os.system(f"git commit -S -s -m '{message}'")
os.system(f"git commit -S -s --amend")
