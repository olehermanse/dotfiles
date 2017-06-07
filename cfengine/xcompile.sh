# alias cf-local-windows-get="rsync -r -l /shared_cfengine/windows/core ~/local_cfengine/windows/core"

alias cf-local-windows="cd $CF_LOCAL_WINDOWS"

# INIT local_cfengine folder:
function cf-local {
    mkdir -p ~/cf_install_win
    rsync -r -l /shared_cfengine/ ~/local_cfengine
    export CF_LOCAL_WINDOWS="~/local_cfengine/windows"
}

function force-pull {
    git fetch origin `git rev-parse --symbolic-full-name --abbrev-ref HEAD` \
    && git reset --hard origin/`git rev-parse --symbolic-full-name --abbrev-ref HEAD`
}

function share-pull {
    git fetch share `git rev-parse --symbolic-full-name --abbrev-ref HEAD` \
    && git reset --hard share/`git rev-parse --symbolic-full-name --abbrev-ref HEAD`
}

# Get changes from shared folder using git - faster than rsync
function cf-local-windows-pull {
    (cd ~/local_cfengine/windows/core \
    && force-pull \
    && cd ~/local_cfengine/windows/enterprise \
    && force-pull)
}

function cf-local-windows-autogen {
    (cd ~/local_cfengine/windows/core \
    && NO_CONFIGURE=1 ./autogen.sh \
    && cd ~/local_cfengine/windows/enterprise \
    && NO_CONFIGURE=1 ./autogen.sh)
}

function cf-local-windows-configure {
    (cd ~/local_cfengine/windows/core \
    && ./configure --with-pcre=/var/cfengine --with-openssl=/var/cfengine \
       --with-lmdb=/var/cfengine --with-pthreads=/var/cfengine --with-libxml2=/var/cfengine \
       --host x86_64-w64-mingw32 --prefix=$HOME/cf_install_win \
    && cd ~/local_cfengine/windows/enterprise \
    && ./configure --with-pcre=/var/cfengine --with-openssl=/var/cfengine \
       --with-lmdb=/var/cfengine --with-pthreads=/var/cfengine --with-libxml2=/var/cfengine \
       --host x86_64-w64-mingw32 --prefix=$HOME/cf_install_win)
}

function cf-local-windows-make {
    rm -rf ~/cf_install_win
    mkdir -p ~/cf_install_win
    (cd ~/local_cfengine/windows/core \
    && make && make install \
    && cd ~/local_cfengine/windows/enterprise \
    && make && make install)
}

# Copy the binaries from local install directory to shared folder
function cf-local-windows-put {
    mkdir -p /shared_cfengine/windows/Cfengine/
    cp -r ~/cf_install_win/* /shared_cfengine/windows/Cfengine/
    cp /shared_cfengine/windows/dll/*.dll /shared_cfengine/windows/Cfengine/bin/
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
    scp -r /shared_cfengine/windows/Cfengine  Administrator@$1:"\"C:/Program files/\""
}

function cf-remote-windows-upload-agent {
    if [ $# != 1 ]; then
        echo "Specify remote IP"
        return 1
    fi
    scp -r /shared_cfengine/windows/Cfengine/bin/cf-agent.exe  Administrator@$1:"\"C:/Program files/Cfengine/bin/\""
}

function cf-remote-windows-upload-exe {
    if [ $# != 1 ]; then
        echo "Specify remote IP"
        return 1
    fi
    scp -r /shared_cfengine/windows/Cfengine/bin/*.exe  Administrator@$1:"\"C:/Program files/Cfengine/bin/\""
}

function cf-remote-windows-upload-dll {
    if [ $# != 1 ]; then
        echo "Specify remote IP"
        return 1
    fi
    scp -r /shared_cfengine/windows/Cfengine/bin/*.dll  Administrator@$1:"\"C:/Program files/Cfengine/bin/\""
}
