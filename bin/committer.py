#!/usr/bin/env python3
"""
Script for running a command and committing the results
"""

import os
import sys
import subprocess

def prompt(message):
    if not input(f"{message} ? y/n: ").lower().startswith("y"):
        sys.exit(1)

def prompt_command(command):
    prompt(f"{command} ? y/n: ")
    return subprocess.run(["bash", "-c", command], stdout=subprocess.PIPE).stdout.decode('utf-8')

history_1 = os.path.expanduser("~/.logs/history_1.log")

command = open(history_1, "r").read()[7:].strip()

script = command.split(" ")[0]

prompt_command("git reset --hard HEAD && git clean -fxd")

output = prompt_command(command)

url = os.getenv("URL")

if not url:
    url = input(f"Please enter permalink URL for {script}: ")

if not url.endswith(script):
    print("URL does not match script")
    sys.exit(1)

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
