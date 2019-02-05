#!/usr/bin/env python3
import sys
from datetime import datetime, timedelta

TF = "%Y-%m-%d.%H:%M:%S"


def str_to_time(string):
    return datetime.strptime(string, TF)


def str_from_time(time):
    return datetime.strftime(time, TF)


def ints(*args):
    for arg in args:
        yield int(arg)


def str_from_delta(time):
    seconds = time.total_seconds()
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    days, hours = divmod(hours, 8)
    days, hours, minutes, seconds = ints(days, hours, minutes, seconds)
    return "{} work days, {} hours, {} minutes, {} seconds".format(
        days, hours, minutes, seconds)


def hours_from_delta(time):
    seconds = time.total_seconds()
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    hours, minutes = ints(hours, minutes)
    return "{}:{} hours".format(hours, minutes)


filename = sys.argv[1]
print("Filename: {}".format(filename))
data_lines = []
file_lines = []


def data_line(line):
    print(line)
    data_lines.append(line)
    file_lines.append(line)


def file_line(line):
    print(line)
    file_lines.append(line)


total = timedelta(0)
days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
day_index = 0
week = timedelta(0)

timestamp = None

with open(filename, "r") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        if line.startswith("#"):
            file_line(line)
            continue
        words = line.split()
        if len(words) < 3 or words[2] not in ["start", "stop"]:
            continue

        day = words[0]
        days_passed = 0

        new_timestamp = words[1][:-1]

        if timestamp:
            days_passed = str_to_time(new_timestamp) - str_to_time(timestamp)
            days_passed = days_passed.days

        command = words[2]
        timestamp = new_timestamp
        assert timestamp == str_from_time(str_to_time(timestamp))

        if command == "start":
            # Produce end of week summary if necessary:
            new_index = days.index(day)
            if week > timedelta(0) and (new_index < day_index
                                        or days_passed >= 5):
                file_line(str_from_delta(week))
                file_line("")
                week = timedelta(0)

            # Add start line to data:
            data_line(line)
        else:
            assert command == "stop"
            day_index = new_index

            then = str_to_time(data_lines[-1].split()[1][:-1])
            now = str_to_time(timestamp)
            delta = now - then

            line = " ".join(words[0:3])
            line += " ({})".format(hours_from_delta(delta))
            total += delta
            week += delta

            data_line(line)

if week.total_seconds() > 0:
    file_line(str_from_delta(week))
    file_line("")

file_line("Total: " + str_from_delta(total))
try:
    with open(sys.argv[2], "w") as f:
        for line in file_lines:
            f.write(line + "\n")
except IndexError:
    pass
