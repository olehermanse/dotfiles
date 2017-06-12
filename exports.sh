export PYTHONSTARTUP=~/edu/.pystartup

export CLICOLOR=1
export LSCOLORS=excxdxdxbxfxfxbhbhexex

export GTEST_ROOT=~/code/googletest/googletest
export GTEST_DIR=~/code/googletest/googletest

export PS1="\\h:\\w $ "
if [[ $- = *i* ]] && (( EUID != 0 )) ; then
    [[ -d ~/.logs ]] || mkdir ~/.logs
    [[ -d ~/.logs/bash ]] || mkdir ~/.logs/bash
    [[ -d ~/.logs/git ]] || mkdir ~/.logs/git
    export PROMPT_COMMAND='
        HIST_1=$(history 1) ;
        DATE=$(date "+%Y-%m-%d.%H:%M:%S")
        echo "$DATE $(pwd) $HIST_1" >> ~/.logs/bash/history-$(date "+%Y-%m-%d").log ;
        if [[ $HIST_1 =~ "git" ]] ; then
            echo "$DATE $(pwd) $HIST_1" >> ~/.logs/git/history-$(date "+%Y-%m-%d").log ;
        fi
    '
fi
