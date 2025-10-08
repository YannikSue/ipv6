#!/bin/bash

# Run pingv6 test in the given container (default: alice)
# Attach wiredock capture before starting this script to see the traffic

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

if [[ -z "$1" || "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: sudo $0 <container_name> [ping_amount] [IPv6_address] [address_prefix]"
    echo "Runs pingv6 test in the given container"
    echo "  <container_name>   Name of the Docker container to run the test in"
    echo "  [ping_amount]      (Optional) Number of ping packets to send (default: 4)"
    echo "  [IPv6_address]     (Optional) IPv6 address to ping (default: fd9f:7fa1:4256::bb)"
    echo "  [address_prefix]   (Optional) Address prefix type: 'unique' for unique local address or 'linklocal' for link-local (default: unique)"
    exit 0
fi

CONTAINER_NAME="$1"
PING_AMOUNT="${2:-4}"
IPv6_ADDRESS="${3:-fd9f:7fa1:4256::bb}"
ADDRESS_PREFIX="${4:-unique}"


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
OUTFILE=/tmp/ping_from_$CONTAINER_NAME.pcap
../helper/wiredock.sh $CONTAINER_NAME $OUTFILE
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
echo --- Executing ping-helper for ipv6 on container $CONTAINER_NAME with $PING_AMOUNT packets ---

if [[ "$ADDRESS_PREFIX" == "linklocal" ]]; then
  IPv6_ADDRESS="fe80::200:ff:fe00:bb%eth0"
fi

../helper/ping-helper.sh $CONTAINER_NAME $PING_AMOUNT $IPv6_ADDRESS
if [[ "$?" != 0 ]]; then
    echo "Failed to run pingv6 in container $CONTAINER_NAME"
    exit -1
else
    echo "pingv6 test in container $CONTAINER_NAME finished -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- pingv6 test done, wireshark has been saved to $OUTFILE ---

read -p "Do you want to view the pcap file in Wireshark now? (y/n): " yn
case "$yn" in
  [Yy]* ) wireshark "$OUTFILE" & ;;
  * ) echo "You can view the pcap file later at $OUTFILE";;
esac