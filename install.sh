#!/bin/bash
# install.sh

# Function to install the script
function install() {
    local scriptPath="$( cd "$(dirname "$0")" ; pwd -P )"
    local installPath="$HOME/bin/xlaravel"

    # Check if symlink for the script already exists
    if [[ -e "$installPath" ]]; then
        echo "Symlink for the script already exists."
        exit 1
    fi

    # Create a symlink for the script
    ln -s "$scriptPath/xlaravel.sh" "$installPath" || exit 1
    chmod +x "$installPath"
    echo "Script symlink created at $installPath"
}

install 

