#!/usr/bin/env bash
# http://stackoverflow.com/a/12197518
# GET DIRECTORY OF THIS SCRIPT (PATH):
pushd . > /dev/null
SETUP_BASH_PATH="${BASH_SOURCE[0]}";
while ([ -h "${SETUP_BASH_PATH}" ]); do
    cd "`dirname "${SETUP_BASH_PATH}"`" || exit "CANNOT CD: `dirname "${SETUP_BASH_PATH}"`"
    SETUP_BASH_PATH="$(readlink "`basename "${SETUP_BASH_PATH}"`")";
done
cd "`dirname "${SETUP_BASH_PATH}"`" > /dev/null || exit "CANNOT CD: `dirname "${SETUP_BASH_PATH}"`"
SETUP_BASH_PATH="`pwd`";
popd  > /dev/null
export SETUP_BASH_PATH

# GENERAL
source ${SETUP_BASH_PATH}"/exports.sh"
source ${SETUP_BASH_PATH}"/aliases.sh"
source ${SETUP_BASH_PATH}"/funcs.sh"
source ${SETUP_BASH_PATH}"/vars.sh"
source ${SETUP_BASH_PATH}"/cfengine/start.sh"

# Platform dependent:
if [[ "$OSTYPE" == "linux-gnu" ]]; then      # LINUX
	source ${SETUP_BASH_PATH}"/linux.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then      # MAC
    source ${SETUP_BASH_PATH}"/mac.sh"
else
	echo "Unrecognized OS:" $OSTYPE
fi
