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

# read env
set -a
source .env
set +a

# substitute, copy to remote, start
envsubst <docker-compose.yml | ssh skynet@$SERVER.local "cat > /home/skynet/docker-compose.yml && cd /home/skynet && docker compose pull && docker compose up -d --remove-orphans && docker image prune -af && docker compose ps"
