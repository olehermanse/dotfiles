#/usr/bin/env bash

# Run this script as root on an AWS Ubuntu 18 VM, you can curl it from GitHub:
# sudo bash
# apt update
# apt upgrade
# curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/master/cfengine/fuzz.sh | bash

apt-get install -y python
apt-get install -y python3-pip
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
git clone https://gitlab.com/rc0r/afl-utils
git clone --recursive https://github.com/cfengine/core.git

cd afl
make -j16
make install
cd ..

export CC=afl-gcc

echo core >/proc/sys/kernel/core_pattern

cd afl-utils
python3 setup.py install
cd ..

echo "source /usr/lib/python3.6/site-packages/exploitable-1.32_rcor-py3.6.egg/exploitable/exploitable.py" >> ~/.gdbinit

cd core
./autogen.sh --enable-debug
make -j16
make install
cd ..

echo '{
"input": "./afl_inputs",
"output": "./afl_outputs",
"target": "/var/cfengine/bin/cf-promises",
"cmdline": "--log-level CRITICAL -c @@"
}
' > afl.conf

rm -rf /home/ubuntu/afl_outputs/
mkdir /home/ubuntu/afl_inputs/
mkdir /home/ubuntu/afl_outputs/

cp /home/ubuntu/core/examples/main.cf /home/ubuntu/afl_inputs/
cp /home/ubuntu/core/examples/mergedata.cf /home/ubuntu/afl_inputs/

# Parallell fuzzing, using afl-multicore (afl-utils):
# afl-multicore -c afl.conf start 8

# Show stats:
# watch afl-whatsup afl_outputs/

# Collect crashes from multiple fuzzers:
# afl-collect -r afl_outputs/ ./collection -- /var/cfengine/bin/cf-promises --log-level CRITICAL -c @@

# Minimize corpus (remove "duplicates", reduce sizes of inputs)
# WARNING: VERY TIME CONSUMING
# afl-minimize -c new_corpus --cmin --cmin-mem-limit=500 --tmin --tmin-mem-limit=500 -j 8 ./afl_outputs/ -- /var/cfengine/bin/cf-promises --log-level CRITICAL -c @@

# WITHOUT afl-utils:

# Commands for fuzzing, cf-promises is safer (has less side effects):
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -- /var/cfengine/bin/cf-promises @@
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -- /var/cfengine/bin/cf-agent -K @@

# Parallell fuzzing, open in different tabs (tmux):
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -M fuzzer01 -- /var/cfengine/bin/cf-promises @@
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -S fuzzer02 -- /var/cfengine/bin/cf-promises @@
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -S fuzzer03 -- /var/cfengine/bin/cf-promises @@
# afl-fuzz -i /home/ubuntu/afl_inputs/ -o /home/ubuntu/afl_outputs/ -S fuzzer04 -- /var/cfengine/bin/cf-promises @@
