#!/usr/bin/env bash
set -e
set -x
sudo useradd -m -d /home/olehermanse -s /bin/bash olehermanse
sudo adduser olehermanse sudo
mkdir -p /home/olehermanse/.ssh/
cp ~/.ssh/authorized_keys /home/olehermanse/.ssh/authorized_keys
chown -R olehermanse:olehermanse /home/olehermanse/
cp ~/.dotfiles_olehermanse/config/sudo/* /etc/sudoers.d/

cp ~/.dotfiles_olehermanse/config/sshd/sshd_config /etc/ssh/sshd_config
systemctl restart sshd
