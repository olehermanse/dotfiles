#!/usr/bin/env python3
import sys
from datetime import datetime, timedelta

TF = "%Y-%m-%d.%H:%M:%S"
DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
COMMANDS = ["start", "stop", "skip"]

# TODOs
# - Add custom timedelta class


# Pure functions:


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
    return f"{days} work days, {hours:02d}:{minutes:02d} hours"


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
    return f"{hours:02d}:{minutes:02d} hours"


def min_to_str(minutes: int):
    assert type(minutes) == int
    result = ""
    if minutes < 0:
        result += "-"
        minutes = -minutes
    hours = minutes // 60
    minutes = minutes % 60
    result += f"{hours:02d}:{minutes:02d} hours"
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
    result += f"{days} days, {hours:02d}:{minutes:02d} hours"
    return result


class WorkLog:
    def __init__(self, filename: str) -> None:
        self.filename = filename
        self.week_work = 0
        self.week_overtime = 0
        self.total_work = 0
        self.total_overtime = 0
        self.day_index = 0
        self.days_this_week = []
        self.skip_days = []
        self.last_line = None
        self.data_lines = []
        self.file_lines = []
        self.timestamp = None

    def data_line(self, line):
        self.last_line = None
        print(line)
        self.data_lines.append(line)
        self.file_lines.append(line)

    def file_line(self, line):
        if not (line == "" and self.last_line == ""):
            print(line)
            self.file_lines.append(line)
        self.last_line = line

    def week_done(self):
        for d in self.skip_days:
            if d in self.days_this_week:
                self.days_this_week.remove(d)
        target_minutes = len(self.days_this_week) * 8 * 60
        actual_minutes = self.week_work
        self.week_overtime = actual_minutes - target_minutes
        # print("Diff: {} - {} = {}".format(min_to_str(actual_minutes), min_to_str(target_minutes), min_to_str(self.week_overtime)))

        self.file_line(
            f"Week: {min_to_str(self.week_work)} ({min_to_str(self.week_overtime)} overtime on {len(self.days_this_week)} days)"
        )
        old_overtime = self.total_overtime
        new_overtime = self.total_overtime + self.week_overtime
        self.file_line(
            f"Overtime: {min_to_str(old_overtime)} + {min_to_str(self.week_overtime)} = {min_to_str(new_overtime)}"
        )
        self.file_line("")

        self.total_overtime += self.week_overtime
        self.total_work += self.week_work
        self.week_work = 0
        self.week_overtime = 0
        self.days_this_week = []
        self.skip_days = []

    def process_work(self, filename):
        print(f"Filename: {filename}")

        with open(filename, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                if line.startswith("#"):
                    self.file_line(line)
                    continue
                words = line.split()
                if len(words) < 3 or words[2] not in COMMANDS:
                    continue

                day = words[0]
                days_passed = 0

                new_timestamp = words[1][:-1]

                if self.timestamp:
                    days_passed = str_to_time(new_timestamp) - str_to_time(
                        self.timestamp
                    )
                    days_passed = days_passed.days

                command = words[2]
                self.timestamp = new_timestamp
                assert self.timestamp == str_from_time(str_to_time(self.timestamp))

                now = str_to_time(self.timestamp)

                # Produce end of week summary if necessary:
                new_index = DAYS.index(day)
                if self.week_work > 0 and (
                    new_index < self.day_index or days_passed >= 5
                ):
                    self.week_done()

                if command == "skip":
                    self.skip_days.append(day)
                    self.data_line(line)
                elif command == "start":
                    if day not in ["Sat", "Sun"] and day not in self.days_this_week:
                        self.days_this_week.append(day)

                    # Add start line to data:
                    self.data_line(line)
                else:
                    assert command == "stop"
                    self.day_index = new_index

                    then = str_to_time(self.data_lines[-1].split()[1][:-1])
                    delta = now - then
                    minutes = int(delta.total_seconds()) // 60

                    line = " ".join(words[0:3])
                    line += f" ({min_to_str(minutes)})"
                    self.week_work += minutes

                    self.data_line(line)
        if self.week_work > 0:
            self.week_done()

        self.file_line("")
        self.file_line("Total: " + min_to_str_days(self.total_work))
        self.file_line("Overtime: " + min_to_str(self.total_overtime))
        try:
            with open(sys.argv[2], "w") as f:
                for line in self.file_lines:
                    f.write(line + "\n")
        except IndexError:
            pass

    def start(self):
        self.process_work(self.filename)


def main():
    log = WorkLog(sys.argv[1])
    log.start()


if __name__ == "__main__":
    main()
