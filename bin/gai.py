#!/usr/bin/env python3

import subprocess
import sys

def unique(a):
    return list(dict.fromkeys(a))

def run_git_command(args):
    """Run a git command and return the output."""
    result = subprocess.run(["git"] + args, capture_output=True, text=True, check=True)
    return result.stdout.rstrip("\n")


def main():
    try:
        # Get the last commit message
        old_message = run_git_command(["log", "-1", "--pretty=%B"])
        processed = old_message
        while "\n\n\n" in processed:
            processed = processed.replace("\n\n\n", "\n\n")
        segments = old_message.split("\n\n")
        assert len(segments) >= 1
        subject_line = segments[0]
        body = ""
        footer = ""

        if len(segments) == 1:
            pass
        elif len(segments) == 2:
            if "Signed-off-by:" in segments[1]:
                footer = segments[1]
            else:
                body = segments[1]
        else:
            body = "\n\n".join(segments[1:-1])
            footer = segments[-1]

        # Build the new message
        parts = [subject_line, ""]

        if body:
            parts.append(body)
            parts.append("")

        CO_AUTHOR_STRING = "Co-authored-by: Claude <noreply@anthropic.com>"
        parts.append(CO_AUTHOR_STRING)

        footer = CO_AUTHOR_STRING + "\n" + footer
        footer = "\n".join(unique(footer.split("\n")))

        parts = [subject_line, body, footer]
        new_message = "\n\n".join(parts)

        if old_message == new_message:
            print("Looks correct - nothing to amend")
            return

        # Amend the commit with the new message
        subprocess.run(
            ["git", "commit", "--amend", "-m", new_message],
            check=True,
            capture_output=True,
            text=True,
        )

        subprocess.run(
            ["git", "log", "-1"],
            check=True,
        )

    except subprocess.CalledProcessError as e:
        print(f"Error running git command: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
