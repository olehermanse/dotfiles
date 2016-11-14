mkdir -p ~/tmp
rm -rf ~/.setup-bash
rm -rf ~/.setup-bash-master
rm -rf ~/tmp/.setup-bash
rm -rf ~/tmp/.setup-bash-master
curl -L https://github.com/olehermanse/.setup-bash/archive/master.zip -o ~/tmp/master.zip
unzip ~/tmp/master.zip -d ~/tmp/
mv ~/tmp/.setup-bash-master ~/.setup-bash

touch ~/.bashrc
touch ~/.bash_profile
grep -q -F 'source ~/.setup-bash/start.sh' ~/.bashrc || echo 'source ~/.setup-bash/start.sh' >> ~/.bashrc
grep -q -F 'source ~/.setup-bash/start.sh' ~/.bash_profile || echo 'source ~/.setup-bash/start.sh' >> ~/.bash_profile
rm -rf ~/tmp
