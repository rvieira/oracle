# This scripts adds hosts to an OEM group
# it reads a text file with a list of fully qualified host names and adds them to the group
# Usage: ./add_hosts_to_oem_group.sh <Group name> <Host list file>
# This script adds hosts to an Oracle Enterprise Manager (OEM) group using the emcli command.
# It takes a group name and a host list file as arguments and uses the emcli command to add the hosts to the group.
# Ensure that the emcli command is available
# and that you have the necessary permissions to add hosts to groups in OEM.
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
# Check if the user has permission to add hosts to groups
if ! emcli get_groups &> /dev/null; then
    echo "You do not have permission to add hosts to groups in OEM. Please check your permissions and try again."
    exit 1
fi
# Function to display usage information
# and exit the script
usage() {
    echo "A group name and a host list file must be provided"
    echo "usage: $0 <Group name> <Host list file>"
    exit 1
}
# Check if the group name and host list file are provided
# If not, display usage information
# and exit the script
if [ $# -lt 2 ]; then
    usage
else
    GROUP_NAME=$1
    HOST_LIST=$2
fi
# Check if the host list file exists
if [ ! -f "$HOST_LIST" ]; then
    echo "Host list file not found: $HOST_LIST"
    exit 1
fi
# Check if the group exists
if ! emcli get_groups | grep -q "^${GROUP_NAME}$"; then
    echo "Group not found: $GROUP_NAME"
    exit 1
fi
# Loop through the host list file and add each host to the group
while IFS= read -r host; do
    # Check if the host is reachable
    if ping -c 1 "$host" &> /dev/null; then
        # Add the host to the group
        emcli modify_group -name="${GROUP_NAME}" -targets="${host}:host"
        if [ $? -eq 0 ]; then
            echo "Added $host to group $GROUP_NAME"
        else
            echo "Failed to add $host to group $GROUP_NAME"
        fi
    else
        echo "Host not reachable: $host"
    fi
done < "$HOST_LIST"
# Check if the emcli command was successful
if [ $? -eq 0 ]; then
    echo "All hosts added to group $GROUP_NAME"
else
    echo "Failed to add hosts to group $GROUP_NAME"
fi
# End of script
# This script is intended to be run on the Oracle Enterprise Manager (OEM) server
# and requires the emcli command to be installed and configured.
# It is recommended to run this script as a user with the necessary permissions to add hosts to groups in OEM.
# Ensure that the emcli command is available
# and that you have the necessary permissions to add hosts to groups in OEM.