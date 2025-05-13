#!/usr/bin/env bash
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ -d "/Users/olehermanse/Library/Python/3.12/bin/" ]
then
    export PATH="/Users/olehermanse/Library/Python/3.12/bin/:$PATH"
fi

function tex {
    pdflatex --shell-escape "$1" && pdflatex --shell-escape "$1" && rm -f ./*.log ./*.out ./*.aux
}

function cleaner {
    find -E . -type d -regex ".*__MACOSX" -exec rm -rvf {} +
    find -E . -type d -regex "\./.*adexl/results" -exec rm -rvf {} +
    find -E . -type d -regex "\./.*adexl/test_states/.*Interactive.*" -exec rm -rvf {} +
    find -E . -type f -regex "\./(.*~|~.*|.*cdslck.*|.*CDS\.log|.*\.DS_Store|\._.+)" -exec rm -v {} +
}
alias clean="cleaner | wc -l"

function cd {
    command cd "$1" || return
    if [ "$CWD" = "$(realpath .)" ]
    then
        return
    fi
    command cd "$(realpath .)" || return
}

if [ -f "$(brew --prefix)/etc/bash_completion" ]
then
    . "$(brew --prefix)/etc/bash_completion"
fi

function notes {
    # Use date only once to ensure no race condition:
    TIME_INFO=$(date "+%Y %a %Y-%m-%d.%H:%M:%S %Y-%m-%d")

    YEAR=$(echo "$TIME_INFO" | cut -f 1 -w)
    DAY=$(echo "$TIME_INFO" | cut -f 2 -w)
    TIME=$(echo "$TIME_INFO" | cut -f 3 -w)
    YMD=$(echo "$TIME_INFO" | cut -f 4 -w)

    TS="$DAY $TIME"

    mkdir -p "$HOME/.logs/"
    mkdir -p "$HOME/.logs/notes/"
    mkdir -p "$HOME/.logs/notes/$YEAR/"
    touch "$HOME/.logs/notes/$YEAR/$MD_FILENAME"
    code "$HOME/.logs/notes" "$HOME/.logs/notes/$YEAR/$YMD.md"
}

function work {
    # Use date only once to ensure no race condition:
    TIME_INFO=$(date "+%Y %a %Y-%m-%d.%H:%M:%S %Y-%m-%d")

    YEAR=$(echo "$TIME_INFO" | cut -f 1 -w)
    DAY=$(echo "$TIME_INFO" | cut -f 2 -w)
    TIME=$(echo "$TIME_INFO" | cut -f 3 -w)
    YMD=$(echo "$TIME_INFO" | cut -f 4 -w)

    TS="$DAY $TIME"

    mkdir -p "$HOME/.logs/"
    mkdir -p "$HOME/.logs/$YEAR"

    if [ "$1" == "show" ] && [ $# -eq 1 ]
    then
        counting.py "$HOME/.logs/$YEAR/work.log" > "$HOME/.logs/$YEAR/work.log.tmp" && cp "$HOME/.logs/$YEAR/work.log.tmp" "$HOME/.logs/$YEAR/work.log"
        less "$HOME/.logs/$YEAR/work.log"
        diff -q "$HOME/.logs/$YEAR/work.log" "$HOME/.logs/$YEAR/work.log.tmp" && rm "$HOME/.logs/$YEAR/work.log.tmp"
        return 0
    fi
    if [ $# -eq 0 ]
    then
        echo "Error: Missing work command" && return 1
        return 0
    fi
    if [ ! $# -eq 1 ]
    then
        # More than one word - arbitrary work logging / timetable:
        echo "$TS: $*" >> "$HOME/.logs/$YEAR/work.log"
        echo "$TS: $*" >> "$HOME/.logs/$YEAR/work.log.backup"
        echo "$TS: $*" >> "$HOME/.logs/work.log.backup"
        echo "$TS: $*" >> "$HOME/.logs/$YEAR/timetable.log"
        return 0
    fi
    if [ "$1" == "start" ] || [ "$1" == "stop" ] || [ "$1" == "skip" ]
    then
        echo "$TS: $*" >> "$HOME/.logs/$YEAR/work.log"
        echo "$TS: $*" >> "$HOME/.logs/$YEAR/work.log.backup"
        echo "$TS: $*" >> "$HOME/.logs/work.log.backup"
        echo "$TS: $*" >> "$HOME/.logs/$YEAR/timetable.log"
        return 0
    fi
    printf "Error: Unrecognized command '%s'\n" "$1" && return 1
}
