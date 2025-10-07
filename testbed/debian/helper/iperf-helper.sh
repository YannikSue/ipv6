#!/bin/bash
# Run iperf3 test in the given container (default: alice)


# Helper input
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 [CONTAINER_NAME]"
    echo "Runs iperf3 test in the specified Docker container."
    echo "If no container name is given, defaults to 'alice'."
    exit 0
fi

CONTAINER_NAME="${1:-alice}"

# Check if container exists
if ! docker ps --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
    echo "Error: Container '$CONTAINER_NAME' not found."
    exit 1
fi

docker exec -it "$CONTAINER_NAME" iperf3 -6 -c fd9f:7fa1:4256::bb