#!/bin/bash
# install.sh

# Function to install the script
function install() {
    local scriptPath="$( cd "$(dirname "$0")" ; pwd -P )"
    local installPath="$HOME/bin/xlaravel.sh"
    local binDir="$HOME/bin"

    # Check if ~/bin directory exists, create it if not
    if [[ ! -d "$binDir" ]]; then
        mkdir -p "$binDir" || exit 1
        echo "Created directory: $binDir"
    fi

    # Check if symlink for the script already exists
    if [[ -e "$installPath" ]]; then
        echo "Symlink for the script already exists."
        exit 1
    fi

    # Create a symlink for the script
    ln -s "$scriptPath/xlaravel.sh" "$installPath" || exit 1
    chmod +x "$installPath"

    # Add ~/bin to the PATH if not already in it
    if [[ ":$PATH:" != *":$binDir:"* ]]; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"  # Add to .bashrc for future sessions
        export PATH="$HOME/bin:$PATH"  # Add to current session
        echo "Added $binDir to PATH"
    fi

    echo "Script symlink created at $installPath"
    echo "You can now run 'xlaravel.sh' from any location."
}

install
