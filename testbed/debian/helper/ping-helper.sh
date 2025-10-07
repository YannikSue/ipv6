#!/bin/bash
# Run iperf3 test in the given container (default: alice)


# Helper input
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 [CONTAINER_NAME] [PING_AMOUNT]"
    echo "Runs ping test in the specified Docker container."
    echo "If no container name is given, defaults to 'alice'."
    echo "If no ping amount is given, defaults to 4."
    exit 0
fi

CONTAINER_NAME="${1:-alice}"
PING_AMOUNT="${2:-4}"
# Check if container exists
if ! docker ps --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
    echo "Error: Container '$CONTAINER_NAME' not found."
    exit 1
fi



docker exec -it "$CONTAINER_NAME" ping -6 -c "$PING_AMOUNT" fd9f:7fa1:4256::bb