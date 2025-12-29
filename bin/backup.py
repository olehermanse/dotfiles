import os
import sys
import getpass
import socket
from datetime import datetime

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

    # cmd = f"cd '{source}' && tar -cz --to-stdout '{name}' | gpg --no-random-seed-file --encrypt --recipient 1AFB7919E3969F50997E6F0318823502992A2BC4 > '{dst}'"
    cmd = f"cd '{source}' && tar -cz --to-stdout '{name}' | openssl enc -e -aes-256-cbc -pbkdf2 -pass 'pass:{password}' > '{dst}'"
    assert "'" in cmd and '"' not in cmd
    cmd = f'bash -c "{cmd}"'
    assert "'" in cmd and '"' in cmd
    command(cmd, censor=password)

def confirmation():
    print("OK? ", end="")
    answer = input()
    if answer.lower() not in ["", "yes", "y", "ye"]:
        sys.exit("Not acknowledged")


def command(cmd: str, censor = None) -> int:
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

def main():
    gpgdir = "./gpg/"
    backups = "./backups/"
    root = os.path.abspath(".") + "/"
    assert os.path.isdir(root)

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
    destination = f"{root}{backups}tmp-backup-{user}-{machine}-{date}-{timestamp}/".replace("/./", "/")
    final = f"{root}{backups}backup-{user}-{machine}-{date}-{timestamp}/".replace("/./", "/")

    log(f"User: {user}")
    log(f"Home: {homedir}")
    log(f"Machine: {machine}")
    log(f"Date: {date}")
    log(f"Timestamp: {timestamp}")
    log(f"Backup root: {root}")
    log(f"Backup folder: {final}")

    password = getpass.getpass()
    confirm = getpass.getpass()
    if confirm != password:
        sys.exit("Password doesn't match")

    cleanup(homedir)

    ensure_dir(gpgdir)
    ensure_dir(backups)
    ensure_dir(destination)
    ensure_file("log.txt")
    ensure_file("README.md", README)

    backup_maybe(homedir, ".gnupg", destination, password)
    backup_maybe(homedir, ".ssh", destination, password)
    backup_maybe(homedir, ".config", destination, password)
    backup_maybe(homedir, ".secrets", destination, password)
    backup_maybe(homedir, ".logs", destination, password)
    backup_maybe(homedir, "code", destination, password)

    command(f"mv '{destination}' '{final}'")
    log("")

if __name__ == "__main__":
    main()
