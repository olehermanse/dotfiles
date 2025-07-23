#!/usr/bin/env bash

mkdir -p ~/tmp
rm -rf ~/tmp/dotfiles
rm -rf ~/tmp/dotfiles-main
curl -L https://github.com/olehermanse/dotfiles/archive/master.zip -o ~/tmp/master.zip
unzip ~/tmp/master.zip -d ~/tmp/

cd ~/tmp/dotfiles-main || exit 'Unable to cd: ~/tmp/dotfiles-main'
bash ./local_install.sh
rm -rf ~/tmp
