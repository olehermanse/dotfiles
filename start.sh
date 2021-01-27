#!/usr/bin/env bash
# http://stackoverflow.com/a/12197518
# GET DIRECTORY OF THIS SCRIPT (PATH):
pushd . > /dev/null
DOTFILES_PATH="${BASH_SOURCE[0]}";
while ([ -h "${DOTFILES_PATH}" ]); do
    cd "`dirname "${DOTFILES_PATH}"`" || exit "CANNOT CD: `dirname "${DOTFILES_PATH}"`"
    DOTFILES_PATH="$(readlink "`basename "${DOTFILES_PATH}"`")";
done
cd "`dirname "${DOTFILES_PATH}"`" > /dev/null || exit "CANNOT CD: `dirname "${DOTFILES_PATH}"`"
DOTFILES_PATH="`pwd`";
popd  > /dev/null
export DOTFILES_PATH

export PATH=${PATH}:${DOTFILES_PATH}/bin
export PATH=${PATH}:${HOME}/bin
export PATH=${PATH}:${HOME}/.local/bin

# GENERAL
source ${DOTFILES_PATH}"/exports.sh"
source ${DOTFILES_PATH}"/aliases.sh"
source ${DOTFILES_PATH}"/funcs.sh"
source ${DOTFILES_PATH}"/vars.sh"
source ${DOTFILES_PATH}"/cfengine/start.sh"

if [ -f "$HOME/.cargo/env" ];
then
    source $HOME/.cargo/env
fi

# Platform dependent:
if [[ "$OSTYPE" == "linux-gnu" ]]; then      # LINUX
	source ${DOTFILES_PATH}"/linux.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then      # MAC
    source ${DOTFILES_PATH}"/mac.sh"
else
	echo "Unrecognized OS:" $OSTYPE
fi
