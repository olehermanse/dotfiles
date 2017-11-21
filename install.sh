#!/usr/bin/env bash
mkdir -p ~/tmp
rm -rf ~/tmp/dotfiles
rm -rf ~/tmp/dotfiles-master
curl -L https://github.com/olehermanse/dotfiles/archive/master.zip -o ~/tmp/master.zip
unzip ~/tmp/master.zip -d ~/tmp/

cd ~/tmp/dotfiles-master || exit 'Unable to cd: ~/tmp/dotfiles-master'
bash ./local_install.sh
rm -rf ~/tmp
