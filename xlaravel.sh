#!/bin/bash

# Function to create a symbolic link and configure Apache
function xamppLaravel() {
    local websitePath=$1
    local xamppHtdocs="/Applications/XAMPP/xamppfiles/htdocs"
    local websiteName=$2
    local namedDomain=${3:-$websiteName}  # Use $3 if set, otherwise use $2 as the default
    local apacheConf="/Applications/XAMPP/xamppfiles/apache2/conf/httpd.conf"
    local vhostsDir="/Applications/XAMPP/xamppfiles/apache2/conf/extra"
    local localDomain="$namedDomain.test"

    # Check if symlink already exists
    # if [[ -e "$xamppHtdocs/$websiteName" ]]; then
    #     echo "Symlink already exists."
    #     exit 1
    # fi

    # Check if symlink already exists
    if [[ -e "$xamppHtdocs/$websiteName" ]]; then
        echo "Removing existing symlink..."
        rm -rf "$xamppHtdocs/$websiteName" || exit 1
    fi

    # Check if the website path exists
    if [[ ! -e "$websitePath" ]]; then
        echo "Website path does not exist."
        exit 1
    fi

    # Check and set permissions
    if [[ ! -w "$xamppHtdocs" ]]; then
        chmod 0755 "$xamppHtdocs"
    fi

    # Create the symbolic link
    ln -s "$websitePath" "$xamppHtdocs/$websiteName" || exit 1
    echo "Symlink created successfully."

    # Add virtual host entry to Apache configuration
    echo -e "\n# XAMPP $websiteName Virtual Host" >> "$apacheConf"
    echo "<VirtualHost *:80>" >> "$apacheConf"
    echo "    DocumentRoot \"$xamppHtdocs/$websiteName/public\"" >> "$apacheConf"
    echo "    ServerName $localDomain" >> "$apacheConf"
    echo "    <Directory \"$xamppHtdocs/$websiteName/public\">" >> "$apacheConf"
    echo "        Options Indexes FollowSymLinks" >> "$apacheConf"
    echo "        AllowOverride All" >> "$apacheConf"
    echo "        Require all granted" >> "$apacheConf"
    echo "    </Directory>" >> "$apacheConf"
    echo "</VirtualHost>" >> "$apacheConf"

    # Update hosts file
    echo "127.0.0.1    $localDomain" | sudo tee -a /etc/hosts > /dev/null

    echo "Apache configuration updated. Restarting Apache for changes to take effect..."
    
    # Restart XAMPP
    restartXampp
}

# Function to restart XAMPP
function restartXampp() {
    local xamppControl="/Applications/XAMPP/xamppfiles/xampp"

    # Check if XAMPP is running
    if pgrep -x "httpd" > /dev/null
    then
        # Stop Apache using sudo
        sudo "$xamppControl" stopapache
    fi

    # Start Apache using sudo
    sudo "$xamppControl" startapache

    echo "XAMPP restarted."
}

# Check if arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <websitePath> <websiteName> [namedDomain]"
    exit 1
fi

# Run the xamppLaravel function
xamppLaravel "$1" "$2" "$3"

# Check if arguments are provided
# if [ $# -ne 2 ]; then
#     echo "Usage: $0 <websitePath> <websiteName>"
#     exit 1
# fi
# # Run the xamppLaravel function
# xamppLaravel "$1" "$2"


# Check if arguments are provided
# if [ $# -ne 1 ]; then
#     echo "Usage: $0 <websiteName>"
#     exit 1
# fi

# Assuming the website files are in the "construction" folder
# websitePath=$(cd "$(dirname "$0")/$1" && pwd)
# websiteName=$1

# Run the xamppLaravel function
# xamppLaravel "$1" "$2"

