#!/usr/bin/bash

alias cf-reinstall="\$DOTFILES_PATH/cfengine/reinstall.sh"
alias cf-aliases='echo "cf-aliases are active"'
alias cf-kill='bash -c "killall cf-execd ; killall cf-serverd ; killall cf-hub ; killall cf-agent; killall cf-monitord"'
alias cf-procs='ps aux | grep [c]f-'

alias test-bootstrap="\$DOTFILES_PATH/cfengine/bootstrap.sh"
alias test-cfnet="\$DOTFILES_PATH/cfengine/cfnet.sh"

alias ci-core="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --test --core --warnings --asan"
alias ci-core-build="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --core --warnings --asan"
alias ci-oss="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --test --core --masterfiles --warnings --asan"
alias ci-ent="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --test --core --masterfiles --ent --warnings --asan"
alias ci-ent-build="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --core --masterfiles --ent --warnings --asan"
alias ci-only-ent="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --test --ent --warnings --asan"
alias ci-only-ent-build="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --ent --warnings --asan"
alias ci-nova="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --test --core --masterfiles --ent --mission-portal --nova --warnings --asan"
alias ci-nova-build="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --core --masterfiles --ent --mission-portal --nova --warnings --asan"
alias ci-only-nova="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --test --nova --warnings --asan"
alias ci-only-nova-build="cd /northern.tech/cfengine/starter_pack && python3 cf-builder.py --rsync ~/cfe --clean --build --nova --warnings --asan"

alias ci-oss-install="cd /home/vagrant/cfe/core && make install && cd ../masterfiles && make install"
alias ci-nova-install="cd /home/vagrant/cfe/core && make install && cd ../masterfiles && make install && cd ../enterprise && make install && cd ../nova && make install"

# Git:
alias cf-git-delete-merged='git branch --merged | egrep -v "(^\*|master|3.24.x|3.21.x|3.18.x|3.15.x|3.12.x|3.10.x|3.7.x)$" | xargs git branch -d'
alias cf-git-maintenance='bash ~/.dotfiles_olehermanse/cfengine/git_maintenance.sh'

function cfbs-all {
    set -x
    (cd /northern.tech/cfengine/cfbs         && bash -c "$1")
    (cd /northern.tech/cfengine/cfbs-index   && bash -c "$1")
    (cd /northern.tech/cfengine/cfbs-web     && bash -c "$1")
    (cd /northern.tech/cfengine/cfbs-modules && bash -c "$1")
    (cd /northern.tech/cfengine/cfbs-example && bash -c "$1")
    set +x
}

function cf-all {
    set -x
    (cd /northern.tech/cfengine/core           && bash -c "$1")
    (cd /northern.tech/cfengine/enterprise     && bash -c "$1")
    (cd /northern.tech/cfengine/nova           && bash -c "$1")
    (cd /northern.tech/cfengine/masterfiles    && bash -c "$1")
    (cd /northern.tech/cfengine/mission-portal && bash -c "$1")
    set +x
}
