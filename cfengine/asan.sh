#/usr/bin/env bash
# curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/master/cfengine/asan.sh | bash

curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/master/cfengine/ubuntu.sh | bash

set -e

cd /home/ubuntu/

git clone https://github.com/cfengine/core.git

cd core
./autogen.sh --enable-debug
make CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address -pthread" -j8
cd tests/unit
make CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address -pthread" -j8 check

cd /home/ubuntu
