if [ $(id -u) != 0 ] ; then echo "Please run as root" ; exit 1 ; fi
killall cf-execd
killall cf-serverd
killall cf-hub
killall cf-agent
rm -rf /var/cfengine/inputs/
cd ~/cfengine/core
make -j2 install
/var/cfengine/bin/cf-key
