#!/usr/bin/env bash
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export ANDROID_HOME=~/Library/Android/sdk
export ANDROID_SDK_ROOT=~/Library/Android/sdk
export NDK_ROOT=~/code/NDK
export ANT_ROOT=/usr/local/Cellar/ant
export NEW_PROJECTS_DIR=~/code/

if test -d "/Users/olehermanse/Library/Python/3.12/bin/"; then
    export PATH="/Users/olehermanse/Library/Python/3.12/bin/:$PATH"
fi

function tex {
    pdflatex --shell-escape $1 && pdflatex --shell-escape $1 && rm -f *.log *.out *.aux
}

function cleaner {
    find -E . -type d -regex ".*__MACOSX" -exec rm -rvf {} +
    find -E . -type d -regex "\./.*adexl/results" -exec rm -rvf {} +
    find -E . -type d -regex "\./.*adexl/test_states/.*Interactive.*" -exec rm -rvf {} +
    find -E . -type f -regex "\./(.*~|~.*|.*cdslck.*|.*CDS\.log|.*\.DS_Store|\._.+)" -exec rm -v {} +
}
alias clean="cleaner | wc -l"

function cd {
    command cd $1 || return
    if [ "$CWD" = "$(realpath .)" ]
    then
        return
    fi
    command cd "$(realpath .)" || return
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

function notes {
    mkdir -p "$HOME/notes/%Y/"
    mkdir -p $(date "+$HOME/notes/%Y/")
    mkdir -p $(date "+$HOME/notes/%Y/%m/")
    touch $(date "+$HOME/notes/%Y/%m/%Y-%m-%d.md")
    code $HOME/notes $(date "+$HOME/notes/%Y/%m/%Y-%m-%d.md")
}

function work {
    TIME="$(date "+%Y-%m-%d.%H:%M:%S")"
    TS="`date +"%a"` $TIME"
    if [ $1 == "show" ] && [ $# -eq 1 ]
    then
        counting.py ~/.logs/work.log > ~/.logs/work.log.tmp && cp ~/.logs/work.log.tmp ~/.logs/work.log ;
        less ~/.logs/work.log ;
        diff -q ~/.logs/work.log ~/.logs/work.log.tmp && rm ~/.logs/work.log.tmp
        return 0;
    fi
    if [ ! $# -eq 0 ]
    then
        echo "Error: Missing work command" && return 1
        return 0;
    fi
    if [ ! $# -eq 1 ]
    then
        # More than one word - arbitrary work logging / timetable:
        echo "$TS: $*" >> ~/.logs/work.log
        echo "$TS: $*" >> ~/.logs/work.log.backup ;
        echo "$TS: $*" >> ~/.logs/timetable.log
        return 0;
    fi
    if [ $1 == "start" ] || [ $1 == "stop" ] || [ $1 == "skip" ]
    then
        echo "$TS: $*" >> ~/.logs/work.log ;
        echo "$TS: $*" >> ~/.logs/work.log.backup ;
        return 0;
    fi
    printf "Error: Unrecognized command '%s'" "$1" && return 1
}
