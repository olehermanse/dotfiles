killall cf-execd
killall cf-serverd
killall cf-hub
killall cf-agent
rm -rf /var/cfengine/inputs/
cd ~/cfengine/core
make -j2 && make -j2 install
