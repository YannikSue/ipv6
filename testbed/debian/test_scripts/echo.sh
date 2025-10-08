#!/bin/bash

# Run echo test in the given container (default: alice)
# Attach wiredock capture before starting this script to see the traffic

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

if [[ -z "$1" || "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: sudo $0 <container_name> [USE_UDP] [IPv6_ADDRESS] [STRING_TO_ECHO]"
    echo "Runs echo test in the given container"
    echo "  <container_name>   Name of the Docker container to run the test in"
    echo "  [USE_UDP]         (Optional) Use UDP instead of TCP (default: false)"
    echo "  [IPv6_ADDRESS]     (Optional) IPv6 address to use (default: fd9f:7fa1:4256::bb)"
    echo "  [STRING_TO_ECHO]   (Optional) String to echo (default: 'Hello, World!')"
    exit 0
fi

CONTAINER_NAME="${1:-alice}"
USE_UDP="${2:-false}"
IPv6_ADDRESS="${3:-fd9f:7fa1:4256::bb}"
STRING_TO_ECHO="${4:-Hello, World!}"

echo -----------------------------------------------------------------------------
echo --- check container ---
# Check if container exists
if ! docker ps --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
    echo "Error: Container '$CONTAINER_NAME' not found."
    exit 1
else
  echo "Container '$CONTAINER_NAME' found -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- connecting wiredock to container $CONTAINER_NAME ---


OUTFILE="/tmp/echo_from_$CONTAINER_NAME.pcap"
../helper/tsharkDock.sh $CONTAINER_NAME $OUTFILE
if [[ "$?" != 0 ]]; then
  echo "Failed to connect wiredock to container $CONTAINER_NAME"
  exit -1
else
  echo "Wiredock connected to container $CONTAINER_NAME -> GOOD"
fi

# Refactor this bit to actually wait until wireshark is fully loaded
echo -----------------------------------------------------------------------------
echo --- Wait for wiredock to be fully loaded ---
sleep 1
echo "Waited 1 seconds -> GOOD"


echo -----------------------------------------------------------------------------
echo --- executing echo-helper for ipv6 on container $CONTAINER_NAME ---


if [[ "$USE_UDP" == "true" ]]; then
  echo "Using UDP for echo test"
else
  echo "Using TCP for echo test"
fi

../helper/echo-helper.sh $CONTAINER_NAME $USE_UDP $IPv6_ADDRESS "$STRING_TO_ECHO"

if [[ "$?" != 0 ]]; then
    echo "Failed to run echo in container $CONTAINER_NAME"
    exit -1
else
    echo "echo test in container $CONTAINER_NAME finished -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- echo test done, wireshark has been saved to $OUTFILE ---

read -p "Do you want to view the pcap file in Wireshark now? (y/n): " yn
case "$yn" in
  [Yy]* ) wireshark "$OUTFILE" & ;;
  * ) echo "You can view the pcap file later at $OUTFILE";;
esac