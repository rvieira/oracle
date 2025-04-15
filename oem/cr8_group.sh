# Creates a group in Oracle OEM
# Usage: ./cr8_group.sh <Group name>
#!/bin/bash
# This script creates a group in Oracle Enterprise Manager (OEM) using the emcli command.
# It takes a group name as an argument and uses the emcli command to create the group.
# Ensure that the emcli command is available
# and that you have the necessary permissions to create groups in OEM.

# Check if emcli is installed
if ! command -v emcli &> /dev/null; then
    echo "emcli could not be found. Please install it and try again."
    exit 1
fi

# Check if the user is logged in to emcli
if ! emcli get_targets &> /dev/null; then
    echo "You are not logged in to emcli. Please log in and try again."
    exit 1
fi

# Check if the user has permission to create groups
if ! emcli get_groups &> /dev/null; then
    echo "You do not have permission to create groups in OEM. Please check your permissions and try again."
    exit 1
fi

# Function to display usage information
# and exit the script
usage() {
    echo "A group name must be provided"
    echo "usage: $0 <Group name>"
    exit 1
}

# Check if the group name is provided
# If not, display usage information
# and exit the script
if [ $# -lt 1 ]; then
    usage
else
    GROUP_NAME=$1
    emcli create_group -name="${GROUP_NAME}"
fi