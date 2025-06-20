#!/usr/bin/env bash

rm -rf ~/.dotfiles_olehermanse
rm -rf ~/.dotfiles_olehermanse-master

cp -r ./ ~/.dotfiles_olehermanse
chmod u+x ~/.dotfiles_olehermanse/bin/counting.py

cp ~/.dotfiles_olehermanse/config/tmux/.tmux.conf ~/.tmux.conf
cp ~/.dotfiles_olehermanse/config/zed/settings.json ~/.config/zed/settings.json

# Platform dependent:
if [[ "$OSTYPE" == "darwin"* ]]; then
    cat ~/.dotfiles_olehermanse/config/tmux/.tmux-osx.conf >> ~/.tmux.conf
fi

touch ~/.bashrc
touch ~/.bash_profile
source_line='source ~/.dotfiles_olehermanse/start.sh'
grep -q -F "$source_line" ~/.bashrc || echo "$source_line" >> ~/.bashrc
grep -q -F "$source_line" ~/.bash_profile || echo "$source_line" >> ~/.bash_profile

# Uninstall old:
sed -i.bu "/.setup-bash/d" $HOME/.bashrc && rm -f $HOME/.bashrc.bu
sed -i.bu "/.setup-bash/d" $HOME/.bash_profile && rm -f $HOME/.bashrc.bu

if [ -d ~/.setup-bash ]; then
   rm -rf ~/.setup-bash
fi

mkdir -p ~/bin
