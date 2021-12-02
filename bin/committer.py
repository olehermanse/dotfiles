#!/usr/bin/env python3
"""
Script for running a command and committing the results
"""

import os
import sys


url = os.getenv("URL")

command = sys.argv[1]

script = command.split(" ")[0]

assert url.endswith(script)

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
{output}
```
"""

os.system(f"git commit -S -s -m '{message}'")
os.system(f"git commit -S -s --amend")
