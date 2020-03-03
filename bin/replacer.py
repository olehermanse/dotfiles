#!/usr/bin/env python3
import sys


def usage(err=None):
    def print_indented(lines):
        for line in lines:
            print(f"\t{line}")

    print("\nUsage:")
    print("\treplacer.py [options] 'from' 'to' 'file' [files...]")
    print("\nOptions:")
    print_indented(["--loop", "--verbose", "--dry-run", "--help"])
    print("\nExamples:")
    print_indented([
        r"find . -name '*.md' -exec python3 replacer.py '\n\n\n' '\n\n' '{}' \;"
    ])
    print("")
    if err:
        sys.exit(err)
    sys.exit(0)


def main(argv):
    executable = argv[0]
    argv = argv[1:]
    arguments = [x for x in argv if not x.startswith("-")]
    options = [x for x in argv if x.startswith("-")]

    verbose = False
    loop = False
    dry_run = False

    for option in options:
        if option == "--verbose":
            verbose = True
        elif option == "--loop":
            loop = True
        elif option == "--dry-run":
            dry_run = True
        elif option == "--help":
            usage()
        else:
            usage(f"Unrecognized option: '{option}'")

    if len(arguments) < 3:
        usage("At least 3 arguments needed; from, to, and file(s)")

    find_escaped = arguments[0]
    replace_escaped = arguments[1]
    files = arguments[2:]

    find = find_escaped.replace(r"\n", "\n").replace(r"\t", "\t")
    replace = replace_escaped.replace(r"\n", "\n").replace(r"\t", "\t")
    change = f"Replacing '{find_escaped}' -> '{replace_escaped}'"

    for file in files:
        if verbose: print(f"Opening '{file}'")
        modified = False
        with open(file, "r") as f:
            try:
                content = f.read()
            except UnicodeDecodeError:
                print(f"Invalid unicode in: {file}")
                sys.exit(1)
            while find in content:
                print(f"{change} in '{file}'")
                content = content.replace(find, replace)
                modified = True
        if modified and not dry_run:
            if verbose: print(f"Overwriting '{file}'")
            with open(file, "w") as f:
                f.write(content)


if __name__ == '__main__':
    main(sys.argv)
