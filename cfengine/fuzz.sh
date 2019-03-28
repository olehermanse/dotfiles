#/usr/bin/env bash

# Run this script as root on an AWS Ubuntu 16 VM, you can curl it from GitHub:
# curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/master/cfengine/fuzz.sh | bash

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

rm -rf /home/ubuntu/afl_outputs/
mkdir /home/ubuntu/afl_inputs/
mkdir /home/ubuntu/afl_outputs/

cp /home/ubuntu/core/examples/main.cf /home/ubuntu/afl_inputs/
cp /home/ubuntu/core/examples/mergedata.cf /home/ubuntu/afl_inputs/

# Commands for fuzzing, cf-promises is safer (has less side effects):
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -- /var/cfengine/bin/cf-promises @@
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -- /var/cfengine/bin/cf-agent -K @@
