#!/usr/bin/env bash

export PYTHONSTARTUP=~/edu/.pystartup

export CLICOLOR=1
export LSCOLORS=excxdxdxbxfxfxbhbhexex

export GTEST_ROOT=~/code/googletest/googletest
export GTEST_DIR=~/code/googletest/googletest

# export PS1="\\h:\\w $ "
export PS1="\u@\h \W $ "
# Log bash commands to ~/.logs/bash/ and ~/.logs/git/
if [[ $- = *i* ]] ; then
    [[ -d ~/.logs ]] || mkdir ~/.logs
    [[ -d ~/.logs/bash ]] || mkdir ~/.logs/bash
    [[ -d ~/.logs/git ]] || mkdir ~/.logs/git
    [[ -d ~/.logs/sudo ]] || mkdir ~/.logs/sudo
    export PROMPT_COMMAND='
        HIST_1=$(history 1) ;
        DATE=$(date "+%Y-%m-%d") ;
        TIME=$(date "+%Y-%m-%d.%H:%M:%S") ;
        echo "$TIME $(pwd) $HIST_1" >> ~/.logs/bash/$DATE.log ;
        if [[ $HIST_1 =~ "git" ]] ; then
            echo "$TIME $(pwd) $HIST_1" >> ~/.logs/git/$DATE.log ;
        fi
        if [[ $HIST_1 =~ "sudo" ]] ; then
            echo "$TIME $(pwd) $HIST_1" >> ~/.logs/sudo/$DATE.log ;
        fi
    '
fi

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind "set mark-symlinked-directories on"
bind "set show-all-if-unmodified on"
bind "TAB: menu-complete"
