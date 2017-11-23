#!/usr/bin/env bash

# Platform dependent:
if [[ "$OSTYPE" == "linux-gnu" ]]; then      # LINUX
    echo "No dependencies registered for Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then      # MAC
    brew install tmux
    brew install reattach-to-user-namespace
else
    echo "Unrecognized OS:" $OSTYPE
fi
