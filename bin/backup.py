#!/usr/bin/env python3
import os
import sys
import json
import getpass
import hashlib
import socket
from datetime import datetime


class BackupUserError(Exception):
    pass


class BackupInternalError(Exception):
    pass


DEFAULT_CONFIG = {
    "profiles": {
        "default": {
            "dirs": [
                ".config",
                ".gnupg",
                ".ssh",
                ".logs",
            ]
        },
        "large": {
            "dirs": [
                ".config",
                ".gnupg",
                ".ssh",
                ".logs",
                "code",
                ".secrets",
            ]
        },
    },
    "password_hashes": [],
}

README = """
# Simple backups

To perform a backup:

```bash
python3 backup.py
```

Decrypt a file:

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -in .config.tgz.enc -out .config.tgz
```
"""


def log(msg: str):
    print(msg)
    with open("./log.txt", "a") as f:
        f.write(msg + "\n")


def backup_maybe(source, name, destination, password):
    assert name
    assert source and os.path.isdir(source)
    assert destination and os.path.isdir(destination)

    src = os.path.join(source, name)
    dst = os.path.join(destination, name) + ".tgz.enc"

    if not os.path.exists(src):
        print(f"Skipping '{name}' - does not exist")
        return

    assert not os.path.exists(dst)
    assert os.path.isdir(src)

    cleanup(src)

    # cmd = f"cd '{source}' && tar -cz '{name}' | gpg --no-random-seed-file --encrypt --recipient 1AFB7919E3969F50997E6F0318823502992A2BC4 > '{dst}'"
    cmd = f"cd '{source}' && tar -cz '{name}' | openssl enc -e -aes-256-cbc -pbkdf2 -pass 'pass:{password}' > '{dst}'"
    assert "'" in cmd and '"' not in cmd
    cmd = f'bash -c "{cmd}"'
    assert "'" in cmd and '"' in cmd
    command(cmd, censor=password)


def confirmation():
    print("OK? ", end="")
    answer = input()
    if answer.lower() not in ["", "yes", "y", "ye"]:
        raise BackupUserError("Not acknowledged")


def command(cmd: str, censor=None) -> int:
    if censor and censor in cmd:
        log(f"Running:\n    {cmd.replace(censor, "<omitted>")}")
    else:
        log(f"Running:\n    {cmd}")
    # confirmation()
    return os.system(cmd)


def ensure_dir(path):
    assert os.path.isdir(path) or not os.path.exists(path)
    if not os.path.exists(path):
        command(f"mkdir '{path}'")
    assert os.path.isdir(path)


def ensure_file(path, content=None):
    if not os.path.exists(path):
        command(f"touch '{path}'")
    if content is None:
        return
    assert os.path.isfile(path)
    in_file = None
    with open(path, "r") as f:
        in_file = f.read()
    if in_file == content:
        return
    with open(path, "w") as f:
        f.write(content)


def cleanup(directory):
    # print(f"Run cleanup in '{directory}' before backup? (y/N) ", end="")
    # answer = input()
    # if not answer in ["yes", "y"]:
    #     print("Skipping cleanup")
    #     return
    command(f"find '{directory}' -name 'node_modules' -type d -exec rm -rf {'{}'} +")
    command(f"find '{directory}' -name '*~' -type f -exec rm {'{}'} +")


def bootstrap():
    script_location = os.path.abspath(os.path.expanduser(sys.argv[0]))
    print(f"Running backup.py from: {script_location}")
    target_location = os.path.abspath("./backup.py")
    if script_location == target_location:
        log("Note: Standalone mode - skipping installation")
        return
    if not os.path.exists(target_location):
        log("Note: Fresh directory - running first time installation")
        command(f"cp '{script_location}' '{target_location}'")
        return
    assert os.path.isfile(target_location)
    running = None
    target = None
    with open(script_location, "r") as f:
        running = f.read()
    with open(target_location, "r") as f:
        target = f.read()
    if running == target:
        log(f"Found matching backup.py: {target_location}")
        return
    log("Note: Updating ./backup.py to latest (running) version")
    with open(target_location, "w") as f:
        f.write(running)


def get_config(path: str):
    if not os.path.exists(path + "config.json"):
        return DEFAULT_CONFIG
    with open(path + "config.json", "r") as f:
        return json.loads(f.read())


def get_profile(user, machine, config, request=None):
    if request:
        if request not in config["profiles"]:
            raise BackupUserError(f"Profile '{request}' does not exist")
        return config["profiles"][request]
    key = user + "@" + machine
    if key in config["profiles"]:
        return config["profiles"][key]
    return config["profiles"]["default"]


def dump_config(path: str, config):
    desired = json.dumps(config, indent=2) + "\n"
    ensure_file(path + "config.json", desired)


def small_hash(string):
    return hashlib.sha256(string.encode("utf-8")).hexdigest()[0:4]


def main():
    bootstrap()
    backups = "./backups/"
    root = os.path.abspath(".") + "/"
    assert os.path.isdir(root)

    if not (os.path.exists(root + "config.json")):
        print("Warning: No config found, will create default")

    user = getpass.getuser()
    assert user and type(user) is str

    homedir = os.path.expanduser("~/")
    assert homedir and type(homedir) is str and os.path.isdir(homedir)

    machine = socket.gethostname()
    assert machine and type(machine) is str

    today = datetime.today()
    date = today.strftime("%Y-%m-%d")
    assert date and type(date) is str
    timestamp = int(today.timestamp())
    assert timestamp > 0

    assert root.endswith("/")
    assert backups.endswith("/")
    destination = f"{root}{backups}tmp-backup-{user}-{machine}-{date}-{timestamp}/"
    destination = destination.replace("/./", "/")
    final = f"{root}{backups}backup-{user}-{machine}-{date}-{timestamp}/"
    final = final.replace("/./", "/")

    log(f"User: {user}")
    log(f"Home: {homedir}")
    log(f"Machine: {machine}")
    log(f"Date: {date}")
    log(f"Timestamp: {timestamp}")
    log(f"Backup root: {root}")
    log(f"Backup folder: {final}")

    request = None
    if len(sys.argv) > 1:
        request = sys.argv[1]

    config = get_config(root)
    profile = get_profile(user, machine, config, request)

    password = getpass.getpass()
    if not password or len(password) < 14:
        raise BackupUserError("Password must be at least 14 characters")
    pw_hash = small_hash(password)
    if "password_hashes" not in config:
        config["password_hashes"] = []
    if pw_hash not in config["password_hashes"]:
        print(
            "New password detected, please confirm by typing the password one more time"
        )
        confirm = getpass.getpass()
        if confirm != password:
            raise BackupUserError("Not sword doesn't match")
        config["password_hashes"].append(pw_hash)

    ensure_dir(backups)
    ensure_dir(destination)
    ensure_file("log.txt")
    ensure_file("README.md", README)

    for directory in profile["dirs"]:
        backup_maybe(homedir, directory, destination, password)

    destination_meta = destination + "meta/"
    ensure_dir(destination_meta)
    command(f"gpg -a --export > {destination_meta}/mypubkeys.asc")
    command(f"gpg --export-ownertrust > {destination_meta}/otrust.txt")
    command(f"cp '{root}backup.py' '{destination_meta}backup.py'")
    command(f"cp '{root}log.txt' '{destination_meta}log.txt'")
    if os.path.exists(root + "config.json"):
        command(f"cp '{root}config.json' '{destination_meta}config_before.json'")
    dump_config(destination_meta, config)
    dump_config(root, config)
    ensure_file(destination_meta, json.dumps(profile, indent=2) + "\n")
    command(f"mv '{destination}' '{final}'")
    log("")


if __name__ == "__main__":
    main()
