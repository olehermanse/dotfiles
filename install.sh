#!/usr/bin/env bash

mkdir -p ~/tmp
rm -rf ~/tmp/dotfiles
rm -rf ~/tmp/dotfiles-main
rm -rf ~/tmp/dotfiles-master
curl -L https://github.com/olehermanse/dotfiles/archive/main.zip -o ~/tmp/main.zip
unzip ~/tmp/main.zip -d ~/tmp/

cd ~/tmp/dotfiles-main || exit 'Unable to cd: ~/tmp/dotfiles-main'
bash ./local_install.sh
rm -rf ~/tmp
