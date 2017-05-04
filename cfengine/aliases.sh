alias cf-reinstall=${SETUP_BASH_PATH}'/cfengine/reinstall.sh'
alias cf-aliases='echo "cf-aliases are active"'
alias cf-kill='bash -c "killall cf-execd ; killall cf-serverd ; killall cf-hub ; killall cf-agent"'
alias cf-net='/var/cfengine/bin/cf-net'

# alias cf-local-windows-get="rsync -r -l ~/cfengine/windows/core ~/local_cfengine/windows/core"

function cf-local {
    mkdir -p ~/cf_install_win
    rsync -r -l ~/cfengine/ ~/local_cfengine
}

function cf-local-windows-pull {
    cd ~/local_cfengine/windows/core \
    && git pull \
    && cd ~/local_cfengine/windows/enterprise \
    && git pull
}

function cf-local-windows-autogen {
    cd ~/local_cfengine/windows/core \
    && NO_CONFIGURE=1 ./autogen.sh \
    && cd ~/local_cfengine/windows/enterprise \
    && NO_CONFIGURE=1 ./autogen.sh
}

function cf-local-windows-configure {
    cd ~/local_cfengine/windows/core \
    && ./configure --with-pcre=/var/cfengine --with-openssl=/var/cfengine \
       --with-lmdb=/var/cfengine --with-pthreads=/var/cfengine --with-libxml2=/var/cfengine \
       --host x86_64-w64-mingw32 --prefix=$HOME/cf_install_win \
    && cd ~/local_cfengine/windows/enterprise \
    && ./configure --with-pcre=/var/cfengine --with-openssl=/var/cfengine \
       --with-lmdb=/var/cfengine --with-pthreads=/var/cfengine --with-libxml2=/var/cfengine \
       --host x86_64-w64-mingw32 --prefix=$HOME/cf_install_win
}

function cf-local-windows-make {
    cd ~/local_cfengine/windows/core \
    && make install \
    && cd ~/local_cfengine/windows/enterprise \
    && make install
}

function cf-local-windows-put {
    rsync -r -l ~/cf_install_win ~/cfengine/windows/cf_install_win
}

function cf-local-windows-all {
    cf-local-windows-pull \
    && cf-local-windows-autogen \
    && cf-local-windows-configure \
    && cf-local-windows-make \
    && cf-local-windows-put
}

function cf-local-windows-pull-make {
    cf-local-windows-pull \
    && cf-local-windows-make \
    && cf-local-windows-put
}

alias test-bootstrap=${SETUP_BASH_PATH}'/cfengine/bootstrap.sh'
alias test-cfnet=${SETUP_BASH_PATH}'/cfengine/cfnet.sh'
