alias cf-reinstall=${SETUP_BASH_PATH}'/cfengine/reinstall.sh'
alias cf-aliases='echo "cf-aliases are active"'
alias cf-kill='bash -c "killall cf-execd ; killall cf-serverd ; killall cf-hub ; killall cf-agent"'
alias cf-net='/var/cfengine/bin/cf-net'

# alias cf-local-windows-get="rsync -r -l ~/cfengine/windows/core ~/cfengine_local/windows/core"

function cf-local {
    mkdir -p ~/cf_install_win
    rsync -r -l ~/cfengine/ ~/cfengine_local
}

function cf-local-windows-autogen {
    cd ~/cfengine_local/windows/core NO_CONFIGURE=1 ./autogen.sh
    cd ~/cfengine_local/windows/enterprise NO_CONFIGURE=1 ./autogen.sh
}

function cf-local-windows-configure {
    cd ~/cfengine_local/windows/core && ./configure --with-pcre=/var/cfengine --with-openssl=/var/cfengine --with-lmdb=/var/cfengine --with-pthreads=/var/cfengine --host x86_64-w64-mingw32 --prefix=$HOME/cf_install_win
    cd ~/cfengine_local/windows/enterprise && ./configure --with-pcre=/var/cfengine --with-openssl=/var/cfengine --with-lmdb=/var/cfengine --with-pthreads=/var/cfengine --host x86_64-w64-mingw32 --prefix=$HOME/cf_install_win
}

function cf-local-windows-pull {
    cd ~/cfengine_local/windows/core && git pull
    cd ~/cfengine_local/windows/enterprise && git pull
}

function cf-local-windows-make {
    cd ~/cfengine_local/windows/core && make install
    cd ~/cfengine_local/windows/enterprise && make install
}

function cf-local-windows-put {
    rsync -r -l ~/cf_install_win ~/cfengine/windows/cf_install_win
}

alias test-bootstrap=${SETUP_BASH_PATH}'/cfengine/bootstrap.sh'
alias test-cfnet=${SETUP_BASH_PATH}'/cfengine/cfnet.sh'
