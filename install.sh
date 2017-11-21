#!/usr/bin/env bash
mkdir -p ~/tmp
rm -rf ~/tmp/dotfiles
rm -rf ~/tmp/dotfiles-master
curl -L https://github.com/olehermanse/dotfiles/archive/master.zip -o ~/tmp/master.zip
unzip ~/tmp/master.zip -d ~/tmp/

rm -rf ~/.dotfiles_olehermanse
rm -rf ~/.dotfiles_olehermanse-master
mv ~/tmp/dotfiles-master ~/.dotfiles_olehermanse

cp ~/.dotfiles_olehermanse/.tmux.conf ~/.tmux.conf

touch ~/.bashrc
touch ~/.bash_profile
newsource='source ~/.dotfiles_olehermanse/start.sh'
grep -q -F $newsource ~/.bashrc || echo $newsource >> ~/.bashrc
grep -q -F $newsource ~/.bash_profile || echo $newsource >> ~/.bash_profile
rm -rf ~/tmp

# Uninstall old:
sed -i.bu "/.setup-bash/d" $HOME/.bashrc && rm -f $HOME/.bashrc.bu
sed -i.bu "/.setup-bash/d" $HOME/.bash_profile && rm -f $HOME/.bashrc.bu

if [ -d ~/.setup-bash ]; then
   rm -rf ~/.setup-bash
fi