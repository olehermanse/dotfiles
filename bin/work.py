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
    return "{} work days, {} hours, {} minutes".format(days, hours, minutes)


def hours_from_delta(time):
    negative = time < timedelta(0)
    seconds = time.total_seconds()
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    hours, minutes = ints(hours, minutes)
    if negative:
        hours = hours * -1
    if minutes < 10:
        minutes = "0" + str(minutes)
    return "{}:{} hours".format(hours, minutes)


filename = sys.argv[1]
print("Filename: {}".format(filename))
data_lines = []
file_lines = []

last_line = None


def data_line(line):
    global last_line
    last_line = None
    print(line)
    data_lines.append(line)
    file_lines.append(line)


def file_line(line):
    global last_line
    if not (line == "" and last_line == ""):
        print(line)
        file_lines.append(line)
    last_line = line

week_work = 0
week_overtime = 0
total_work = 0
total_overtime = 0
days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
day_index = 0
days_this_week = []
skip_days = []

commands = ["start", "stop", "skip"]

timestamp = None

def min_to_str(minutes: int):
    assert type(minutes) == int
    result = ""
    if minutes < 0:
        result += "-"
        minutes = -minutes
    hours = minutes // 60
    minutes = minutes % 60
    result += "{:02d}:{:02d} hours".format(hours, minutes)
    return result

def min_to_str_days(minutes: int):
    assert type(minutes) == int
    result = ""
    if minutes < 0:
        result += "-"
        minutes = -minutes
    days = minutes // (8 * 60)
    hours = (minutes % (24 * 60)) // 60
    minutes = minutes % 60
    result += "{:02d} days, {:02d}:{:02d} hours".format(days, hours, minutes)
    return result

def week_done():
    global week_work
    global week_overtime
    global total_work
    global total_overtime
    global days_this_week
    global skip_days
    global overtime_minutes
    for d in skip_days:
        if d in days_this_week:
            days_this_week.remove(d)
    target_minutes = len(days_this_week) * 8 * 60
    actual_minutes = week_work
    week_overtime = actual_minutes - target_minutes
    # print("Diff: {} - {} = {}".format(min_to_str(actual_minutes), min_to_str(target_minutes), min_to_str(week_overtime)))

    file_line("Week: {} ({} overtime on {} days)".format(
        min_to_str(week_work), min_to_str(week_overtime), len(days_this_week)))
    old_overtime = total_overtime
    new_overtime = total_overtime + week_overtime
    file_line("Overtime: {} + {} = {}".format(min_to_str(old_overtime), min_to_str(week_overtime), min_to_str(new_overtime)))
    file_line("")

    total_overtime += week_overtime
    total_work += week_work
    week_work = 0
    week_overtime = 0
    days_this_week = []
    skip_days = []


with open(filename, "r") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        if line.startswith("#"):
            file_line(line)
            continue
        words = line.split()
        if len(words) < 3 or words[2] not in commands:
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

        now = str_to_time(timestamp)

        # Produce end of week summary if necessary:
        new_index = days.index(day)
        if week_work > 0 and (new_index < day_index or days_passed >= 5):
            week_done()

        if command == "skip":
            skip_days.append(day)
            data_line(line)
        elif command == "start":
            if (day not in ["Sat", "Sun"] and day not in days_this_week):
                days_this_week.append(day)

            # Add start line to data:
            data_line(line)
        else:
            assert command == "stop"
            day_index = new_index

            then = str_to_time(data_lines[-1].split()[1][:-1])
            delta = now - then
            minutes = int(delta.total_seconds()) // 60

            line = " ".join(words[0:3])
            line += " ({})".format(min_to_str(minutes))
            total_work += minutes
            week_work += minutes

            data_line(line)

if week_work > 0:
    week_done()

file_line("")
file_line("Total: " + min_to_str_days(total_work))
file_line("Overtime: " + min_to_str(total_overtime))
try:
    with open(sys.argv[2], "w") as f:
        for line in file_lines:
            f.write(line + "\n")
except IndexError:
    pass
