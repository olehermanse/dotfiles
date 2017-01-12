if [ $(id -u) != 0 ] ; then echo "Please run as root" ; exit 1 ; fi
killall cf-execd
killall cf-serverd
killall cf-hub
killall cf-agent
rm -rf /var/cfengine/inputs/
cd ~/cfengine/core
make -j2 install
/var/cfengine/bin/cf-key
grep -q -F 'myhostname' /etc/hosts || echo '192.168.50.50 myhostname' >> /etc/hosts
