#!/bin/bash
# Run echo test in the given container (default: alice)


# Helper input
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 [CONTAINER_NAME] [IPv6_ADDRESS] [STRING_TO_ECHO]"
    echo "Runs echo test in the specified Docker container."
    echo "If no container name is given, defaults to 'alice'."
    echo "If no IPv6 address is given, defaults to 'fd9f:7fa1:4256::bb'."
    echo "If no string to echo is given, defaults to 'Hello, World!'."
    exit 0
fi

CONTAINER_NAME="${1:-alice}"
IPv6_ADDRESS="${2:-fd9f:7fa1:4256::bb}"
STRING_TO_ECHO="${3:-Hello, World!}"

# Check if container exists
if ! docker ps --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
    echo "Error: Container '$CONTAINER_NAME' not found."
    exit 1
fi



# docker exec -it "$CONTAINER_NAME" nc -6 "$IPv6_ADDRESS" 7 "$STRING_TO_ECHO"
docker exec -it "$CONTAINER_NAME" sh -c "echo '$STRING_TO_ECHO' | nc -6 $IPv6_ADDRESS 7 -q 1"