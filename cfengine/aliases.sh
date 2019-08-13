alias cf-reinstall=${DOTFILES_PATH}'/cfengine/reinstall.sh'
alias cf-aliases='echo "cf-aliases are active"'
alias cf-kill='bash -c "killall cf-execd ; killall cf-serverd ; killall cf-hub ; killall cf-agent; killall cf-monitord"'
alias cf-procs='ps aux | grep [c]f-'

alias test-bootstrap=${DOTFILES_PATH}'/cfengine/bootstrap.sh'
alias test-cfnet=${DOTFILES_PATH}'/cfengine/cfnet.sh'

alias ci-core="cd /northern.tech/cfengine/starter_pack && python3 cfbuilder.py --rsync ~/cfe --clean --build --test --core --warnings"
alias ci-oss="cd /northern.tech/cfengine/starter_pack && python3 cfbuilder.py --rsync ~/cfe --clean --build --test --core --masterfiles --warnings"
alias ci-ent="cd /northern.tech/cfengine/starter_pack && python3 cfbuilder.py --rsync ~/cfe --clean --build --test --core --masterfiles --ent --warnings"
alias ci-nova="cd /northern.tech/cfengine/starter_pack && python3 cfbuilder.py --rsync ~/cfe --clean --build --test --core --masterfiles --ent --nova --warnings"

# Git:
alias cf-git-delete-merged='git branch --merged | egrep -v "(^\*|master|3.12.x|3.10.x|3.7.x)$" | xargs git branch -d'
alias cf-git-maintenance='bash ~/.dotfiles_olehermanse/cfengine/git_maintenance.sh'
