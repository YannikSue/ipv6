#!/bin/bash

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

