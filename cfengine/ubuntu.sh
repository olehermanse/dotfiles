#/usr/bin/env bash
# curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/main/cfengine/ubuntu.sh | bash

apt-get update -y
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

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
