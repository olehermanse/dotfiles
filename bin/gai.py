#!/usr/bin/env python3

import subprocess
import sys


def run_git_command(args):
    """Run a git command and return the output."""
    result = subprocess.run(["git"] + args, capture_output=True, text=True, check=True)
    return result.stdout.rstrip("\n")


def parse_commit_body(rest):
    """Parse the commit body to separate body and footer."""
    if not rest:
        return "", ""

    # Split into segments separated by empty lines
    segments = []
    current_segment = []

    for line in rest.split("\n"):
        if line.strip() == "":
            # Empty line
            if current_segment:
                segments.append("\n".join(current_segment))
                current_segment = []
        else:
            # Non-empty line
            current_segment.append(line)

    # Add the last segment if any
    if current_segment:
        segments.append("\n".join(current_segment))

    body = ""
    footer = ""

    if len(segments) >= 2:
        # 2+ segments: last is footer, rest is body
        body = "\n\n".join(segments[:-1])
        footer = segments[-1]
    elif len(segments) == 1:
        # 1 segment: check for "Signed-off-by"
        if "Signed-off-by" in segments[0]:
            footer = segments[0]
        else:
            body = segments[0]

    return body, footer


def main():
    try:
        # Get the last commit message
        subject_line = run_git_command(["log", "-1", "--pretty=%s"])
        rest = run_git_command(["log", "-1", "--pretty=%b"])

        # Parse body and footer
        body, footer = parse_commit_body(rest)

        # Build the new message
        parts = [subject_line, ""]

        if body:
            parts.append(body)
            parts.append("")

        co_author_string = "Co-authored-by: Claude <noreply@anthropic.com>"
        parts.append(co_author_string)

        if footer:
            for line in footer.splitlines():
                if line == co_author_string:
                    continue
                parts.append(line)

        new_message = "\n".join(parts)

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
