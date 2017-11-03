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
grep -q -F 'source ~/.dotfiles_olehermanse/start.sh' ~/.bashrc || echo 'source ~/.dotfiles_olehermanse/start.sh' >> ~/.bashrc
grep -q -F 'source ~/.dotfiles_olehermanse/start.sh' ~/.bash_profile || echo 'source ~/.dotfiles_olehermanse/start.sh' >> ~/.bash_profile
rm -rf ~/tmp
