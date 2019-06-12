set -e

function cf-git-delete-merged () {
    git branch --merged | egrep -v "(^\*|master|3.12.x|3.10.x|3.7.x)" | xargs git branch -d
}

cd /northern.tech/cfengine/starter_pack
python3 cfbuilder.py --core --ent --nova --buildscr --masterfiles --checkout 3.10.x --fetch --rebase upstream/3.10.x --clean --push
cd /northern.tech/cfengine/core && cf-git-delete-merged
cd /northern.tech/cfengine/enterprise && cf-git-delete-merged
cd /northern.tech/cfengine/nova && cf-git-delete-merged
cd /northern.tech/cfengine/buildscripts && cf-git-delete-merged
cd /northern.tech/cfengine/masterfiles && cf-git-delete-merged

cd /northern.tech/cfengine/starter_pack
python3 cfbuilder.py --core --ent --nova --buildscr --masterfiles --checkout 3.12.x --rebase upstream/3.12.x --clean --push
cd /northern.tech/cfengine/core && cf-git-delete-merged
cd /northern.tech/cfengine/enterprise && cf-git-delete-merged
cd /northern.tech/cfengine/nova && cf-git-delete-merged
cd /northern.tech/cfengine/buildscripts && cf-git-delete-merged
cd /northern.tech/cfengine/masterfiles && cf-git-delete-merged

cd /northern.tech/cfengine/starter_pack
python3 cfbuilder.py --core --ent --nova --buildscr --masterfiles --checkout master --rebase upstream/master --clean --push
cd /northern.tech/cfengine/core && cf-git-delete-merged
cd /northern.tech/cfengine/enterprise && cf-git-delete-merged
cd /northern.tech/cfengine/nova && cf-git-delete-merged
cd /northern.tech/cfengine/buildscripts && cf-git-delete-merged
cd /northern.tech/cfengine/masterfiles && cf-git-delete-merged
