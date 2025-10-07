#!/bin/bash

# Run iperf3 test in the given container (default: alice)
# Attach wiredock capture before starting this script to see the traffic

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

if [[ -z "$1" || "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: sudo $0 <container_name>"
    echo "Runs iperf3 test in the given container"
    exit 0
fi

CONTAINER_NAME="$1"

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

WIRESHARK_OUTFILE="./test.pcap"  # automatically stop after 20 seconds
WIRESHARK_CAPTURE_DURATION=10      # duration in seconds
../helper/wiredock.sh $CONTAINER_NAME "-w $WIRESHARK_OUTFILE -a duration:$WIRESHARK_CAPTURE_DURATION" TRUE
if [[ "$?" != 0 ]]; then
  echo "Failed to connect wiredock to container $CONTAINER_NAME"
  exit -1
else
  echo "Wiredock connected to container $CONTAINER_NAME -> GOOD"
fi

# Refactor this bit to actually wait until wireshark is fully loaded
echo -----------------------------------------------------------------------------
echo --- Wait for wiredock to be fully loaded ---
sleep 5
echo "Waited 5 seconds -> GOOD"


echo -----------------------------------------------------------------------------
echo --- executing iperf-helper for ipv6 on container $CONTAINER_NAME ---



../helper/iperf-helper.sh $CONTAINER_NAME
if [[ "$?" != 0 ]]; then
    echo "Failed to run iperf3 in container $CONTAINER_NAME"
    exit -1
else
    echo "iperf3 test in container $CONTAINER_NAME finished -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- iperf3 test done, wireshark can now be saved ---