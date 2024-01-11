#!/bin/bash

# Function to create a symbolic link and configure Apache
function xamppLaravel() {
    local websitePath=$1
    local xamppHtdocs="/path/to/xampp/htdocs"
    local websiteName=$2
    local apacheConf="/path/to/xampp/apache2/conf/httpd.conf"
    local vhostsDir="/path/to/xampp/apache2/conf/extra"
    local localDomain="$websiteName.test"

    # Check if symlink already exists
    if [[ -e "$xamppHtdocs/$websiteName" ]]; then
        echo "Symlink already exists."
        exit 1
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

    echo "Apache configuration updated. Restart Apache for changes to take effect."
}

# Check if arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <websitePath> <websiteName>"
    exit 1
fi

# Run the xamppLaravel function
xamppLaravel "$1" "$2"
