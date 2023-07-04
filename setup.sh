#!/bin/sh

#
# (c) Qnetix LTD 2023
#    ____                 __   _      
#   / __ \  ____   ___   / /_ (_)_  __
#  / / / / / __ \ / _ \ / __// /| |/_/
# / /_/ / / / / //  __// /_ / /_>  <  
# \___\_\/_/ /_/ \___/ \__//_//_/|_|
#

# -e option instructs bash to immediately exit if any command [1] has a non-zero exit status
# We do not want users to end up with a partially working install, so we exit the script
# instead of continuing the installation with something broken
set -e

# Append common folders to the PATH to ensure that all basic commands are available.
export PATH=':/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

if [ -z "${USER}" ]; then
    USER="$(id -un)"
fi

if ! command -v git &> /dev/null
then
    echo "Git is not installed. Please install Git before running this script."
    exit 1
elif ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker before running this script."
    exit 1
else
    echo "All required dependencies are installed."
fi

if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run it with sudo."
    exit 1
fi

if [ -f /var/lib/qnetix/vars/ZPINSTALLED ]
then
    echo "======================================================================"
    echo "| Zabbix Proxy is already installed, would you like to reinstall it? |"
    echo "|   PLEASE NOTE THAT THIS WILL DESTROY ANY CURRENT CUSTOM CONFIGS    |"
    echo "|                 AND ALL DOCKER CONTAINERS / VOLUMES                |"
    echo "|               PLEASE MAKE A BACKUP BEFORE CONTINUING.              |"
    echo "======================================================================"
    if [ "${confirm}" != "Y" ] && [ "${confirm}" != "y" ]
    then
        echo "Script canceled. Exiting..."
        exit 0
    fi
    docker rm $(docker ps -aq) 2> /dev/null
    docker rmi $(docker images -q) 2> /dev/null
    docker volume rm $(docker volume ls -q) 2> /dev/null
    random_dir=$(mktemp -d /tmp/XXXXXXXX)
    git clone https://github.com/qnetix-io/qn-zprxy-containers.git "$random_dir"
    cp -r "$random_dir"/* /var/lib/qnetix
    chmod +x /var/lib/qnetix/*.sh
    chmod 700 -R /var/lib/qnetix/
else
    mkdir -p /var/lib/qnetix/
    random_dir=$(mktemp -d /tmp/XXXXXXXX)
    git clone https://github.com/qnetix-io/qn-zprxy-containers.git "$random_dir"
    cp -r "$random_dir"/* /var/lib/qnetix
    chmod +x /var/lib/qnetix/*.sh
    chmod 700 -R /var/lib/qnetix/
fi

# Detect the shell being used
current_shell=$(basename "$SHELL")

# Set the source files and target directory based on the shell type
source_dir="/var/lib/qnetix/"
target_dir="$HOME"

if [ "$current_shell" = "bash" ]; then
    files="bash-menu bash-menu-estate"
else 
    files="sh-menu"
fi

# Create symbolic links for each source file in the target directory
for file in "${files[@]}"; do
    # Check if the file exists before creating a symbolic link
    if [ -f "$source_dir$file" ]; then
        ln -s "$source_dir$file" "$target_dir/$file"
    fi
done

# Create the alias command as a separate variable
alias_command=$(readlink -f "$target_dir/menu")

# Echo the alias command into the .profile file
echo "alias zproxy='$alias_command'" >> "$HOME/.profile"
