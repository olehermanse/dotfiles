#/usr/bin/env bash
# curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/main/cfengine/asan.sh | bash

curl -L -s https://raw.githubusercontent.com/olehermanse/dotfiles/main/cfengine/ubuntu.sh | bash

set -e

cd /home/ubuntu/

git clone --recursive https://github.com/cfengine/core.git

cd core
./autogen.sh --enable-debug
make CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address -pthread" -j8
cd tests/unit
make CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address -pthread" -j8 check 2>&1 | tee /home/ubuntu/unit_tests.txt

cd /home/ubuntu
