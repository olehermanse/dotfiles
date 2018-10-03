#/usr/bin/env bash
# curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/master/cfengine/ubuntu.sh | bash

apt-get update -y
apt-get upgrade -y

apt-get install -y python
apt-get install -y autoconf
apt-get install -y libtool
apt-get install -y liblmdb-dev
apt-get install -y libssl-dev
apt-get install -y libpcre3-dev
apt-get install -y libpam0g-dev
apt-get install -y make
apt-get install -y flex
apt-get install -y bison

cd /home/ubuntu/

git clone https://github.com/cfengine/core.git

cd core
./autogen.sh --enable-debug
make -j8
cd ..
