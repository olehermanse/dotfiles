#!/usr/bin/env python3

import os
import sys
import random
import string
from time import sleep


def random_boolean():
    return random.choice([True, False])


def write_random_file(size, path):
    if os.path.exists(path):
        return
    print("Writing to {} ({} KiB)".format(path, size))
    with open(path, 'wb') as fout:
        for i in range(size):
            fout.write(os.urandom(1024))


def random_filename():
    return ''.join(
        random.choices(string.ascii_uppercase + string.digits, k=32))


def random_file_path(directory):
    return os.path.abspath(directory + "/" + random_filename())


def create_random_file(directory, unit=1024):
    path = random_file_path(directory)
    multiplier = random.randint(1, 5)
    while random_boolean() and multiplier < 100:
        multiplier *= random.randint(2, 3)
    multiplier = min(100, multiplier)
    write_random_file(multiplier * unit, path)


def fill_with_files(directory, unit=1024):
    counter = 0
    try:
        while True:
            sleep(0.1)
            create_random_file(directory, unit)
            counter += 1
    except OSError:
        print("Wrote {} random files".format(counter))


def write_big_files(directory):
    print("Writing BIG files")
    fill_with_files(directory, 1024)
    print("No more space for big files")


def write_small_files(directory):
    print("Writing SMALL files")
    fill_with_files(directory, 1)
    print("Drive out of space")


def delete_files(directory, half=False):
    files = os.listdir(directory)
    files = list(filter(lambda x: not x.startswith("."), files))
    files = [os.path.abspath(directory + "/" + x) for x in files]
    files = list(filter(os.path.isfile, files))
    random.shuffle(files)
    if half:
        files = files[::2]
    print("Deleting {} files".format(len(files)))
    for file in files:
        assert os.path.isfile(file)
        print("Deleting {}".format(file))
        os.remove(file)
    print("Deleted {} files".format(len(files)))


def main():
    directory = sys.argv[1]
    while True:
        write_big_files(directory)
        delete_files(directory, half=True)
        write_small_files(directory)
        delete_files(directory, half=False)


if __name__ == "__main__":
    main()
