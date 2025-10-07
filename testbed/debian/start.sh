#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <argument>"
  exit 1
fi

WIREDOCK="$1"
echo "Argument provided: $WIREDOCK"

echo -----------------------------------------------------------------------------
echo --- stop running container ---

docker compose down
if [[ "$?" != 0 ]]; then
  echo "Failed to stop running container"
  exit -1
else
  echo "Running container stopped -> GOOD"
fi

echo -----------------------------------------------------------------------------
echo --- starting container ---

docker compose up -d
if [[ "$?" != 0 ]]; then
  echo "Failed to start container"
  exit -1
else
  echo "Container started -> GOOD"
fi

if [[ "$WIREDOCK" == "wiredock" ]]; then
  echo -----------------------------------------------------------------------------
  echo --- starting wiredock ---

  sudo ./helper/wiredock.sh alice
  if [[ "$?" != 0 ]]; then
    echo "Failed to start wiredock"
    exit -1
  else
    echo "Wiredock started -> GOOD"
  fi
fi



