#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Usage: ./compose.sh [server-name]
# If no server-name is given the script uses the local hostname (short).
SERVER="${1-}"
if [ -z "$SERVER" ]; then
  SERVER="$(hostname -s)"
fi

# Look for a matching subdirectory (first check exact child, then case-insensitive search)
if [ -d "./$SERVER" ]; then
  DIR="./$SERVER"
else
  DIR="$(find . -maxdepth 2 -type d -iname "$SERVER" -print -quit || true)"
fi

if [ -z "$DIR" ]; then
  echo "Error: no subdirectory matching '$SERVER' found in $(pwd)" >&2
  exit 1
fi

echo "Entering directory: $DIR"
cd "$DIR"

# Verify docker is available
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not installed or not in PATH" >&2
  exit 1
fi

echo "Pulling images..."
docker compose pull

echo "Starting containers..."
docker compose up -d --remove-orphans

echo "Cleaning up..."
docker image prune -af

echo "Completed update and start in $DIR"
docker compose ps