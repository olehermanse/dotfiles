alias cf-reinstall=${SETUP_BASH_PATH}'/cfengine/reinstall.sh'
alias cf-aliases='echo "cf-aliases are active"'
alias cf-kill='bash -c "killall cf-execd ; killall cf-serverd ; killall cf-hub ; killall cf-agent"'
alias cf-net='/var/cfengine/bin/cf-net'

# alias cf-local-windows-get="rsync -r -l ~/cfengine/windows/core ~/local_cfengine/windows/core"

# INIT local_cfengine folder:
function cf-local {
    mkdir -p ~/cf_install_win
    rsync -r -l ~/cfengine/ ~/local_cfengine
}

# Get changes from shared folder using git pull - faster than rsync
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
    rm -rf ~/cf_install_win
    cd ~/local_cfengine/windows/core \
    && make && make install \
    && cd ~/local_cfengine/windows/enterprise \
    && make && make install
}

# Copy the binaries from local install directory to shared folder
function cf-local-windows-put {
    rm -r ~/cfengine/windows/cf_install_win
    cp -r ~/cf_install_win ~/cfengine/windows/
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

function cf-remote-windows-upload {
    if [ $# != 1 ]; then
        echo "Specify remote IP"
        return 1
    fi
    scp -r /shared_cfengine/windows/cf_install_win Administrator@$1:
}

function cf-remote-windows-upload-bin {
    if [ $# != 1 ]; then
        echo "Specify remote IP"
        return 1
    fi
    scp -r /shared_cfengine/windows/cf_install_win/bin/cf-agent.exe Administrator@$1:
}

alias test-bootstrap=${SETUP_BASH_PATH}'/cfengine/bootstrap.sh'
alias test-cfnet=${SETUP_BASH_PATH}'/cfengine/cfnet.sh'
