#/usr/bin/env bash

# curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/master/bin/fuzz.sh | bash

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

git clone https://github.com/mirrorer/afl.git
git clone https://github.com/cfengine/core.git

cd afl
make -j16
make install
cd ..

export CC=afl-gcc

echo core >/proc/sys/kernel/core_pattern

cd core
./autogen.sh --enable-debug
make -j16
make install
cd ..

mkdir /home/ubuntu/afl_inputs/
mkdir /home/ubuntu/afl_outputs/

cp /home/ubuntu/core/examples/main.cf /home/ubuntu/afl_inputs/
