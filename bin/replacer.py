import sys

if len(sys.argv) != 4:
    sys.exit("Usage: replacer.py 'from\n' 'to\n' '/path/to/file'")

match_escaped = sys.argv[1]
replacement_escaped = sys.argv[2]
file = sys.argv[3]

match = match_escaped.replace(r"\n", "\n")
replacement = replacement_escaped.replace(r"\n", "\n")

with open(file, "r") as f:
    content = f.read()
    if match in content:
        print(
            f"Replacing '{match_escaped}' -> '{replacement_escaped}' in '{file}'"
        )
        content = content.replace(match, replacement)
    else:
        sys.exit(0)
with open(file, "w") as f:
    f.write(content)
