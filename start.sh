# GENERAL
source ".setup-bash/exports.sh"
source ".setup-bash/aliases.sh"
source ".setup-bash/funcs.sh"

# Platform dependent:
if [[ "$OSTYPE" == "linux-gnu" ]]; then      # LINUX
	source ".setup-bash/linux.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then    # MAC
    source ".setup-bash/mac.sh"
else
	echo "I'm a " $OSTYPE
fi
