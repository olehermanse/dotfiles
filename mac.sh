export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export ANDROID_HOME=~/Library/Android/sdk
export ANDROID_SDK_ROOT=~/Library/Android/sdk
export NDK_ROOT=~/Dev/NDK
export ANT_ROOT=/usr/local/Cellar/ant
export NEW_PROJECTS_DIR=~/github/

alias logisim='open /Applications/Logisim.app'
alias clearhistory='rm -fv ~/.bash_history && touch ~/.bash_history && unset HISTFILE'

bind TAB:menu-complete

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

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
