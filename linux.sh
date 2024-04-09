#!/usr/bin/env bash
if [ -f "/local/lib/setupfiles/bashrc" ]; then
    source /local/lib/setupfiles/bashrc
fi
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
if [ -d "/snacks/bin" ]; then
    export PATH="$PATH:/snacks/bin/"
fi

if [ -d "/root/.deno" ]; then
  export DENO_INSTALL="/root/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

if [ -d "$HOME/.deno" ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

LS_COLORS="$LS_COLORS:di=00;33"


if hash emacs-newest 2>/dev/null; then
    alias emacs='emacs-newest'
fi

alias copy-cfengine="rsync -r --copy-links /shared_cfengine/ ~/local_cfengine"

alias age='~baldersh/pub/aoe2 shm'
alias cadence='cd ~/programs/Cadence2/ && source CRN90LP_session_IC616 && virtuoso& \r'
alias ff='firefox&'
alias logisim='java -jar ~/programs/logisim-generic-2.7.1.jar&'
alias g='gedit&'

alias publish='python3 ~/edu/website/compile.py && rm -rf ~/www_docs && cp -R ~/edu/website ~/www_docs && chmod -R a+rX ~/www_docs'

function cleaner {
    find . -type d -regex ".*__MACOSX" -exec rm -rvf {} +
    find . -type d -regex "\.\/.*adexl\/results" -exec rm -rvf {} +
    find . -type d -regex "\.\/.*adexl\/test_states\/.*Interactive.*" -exec rm -rvf {} +
    find . -type f -regex "\.\/.*\(~\|~.*\|cdslck\|CDS\.log\|\.DS_Store\|\._.*\)" -exec rm -v {} +
}
alias clean="cleaner | wc -l"
