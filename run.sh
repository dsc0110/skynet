#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Usage: ./compose.sh [server-name]
# If no server-name is given, uses the local hostname (short).
SERVER="${1-}"
if [ -z "$SERVER" ]; then
  SERVER="$(hostname -s)"
  # Map specific hostname if needed
  if [ "$SERVER" == "md63kpfc" ]; then
    SERVER="hades"
  fi
fi

# Validate server name to prevent injection
if [[ ! "$SERVER" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Error: Invalid server name '$SERVER'. Only alphanumeric, underscores, and hyphens allowed." >&2
  exit 1
fi

# Define paths
SERVERS_DIR="./servers"
COMPOSE_FILE="${SERVERS_DIR}/${SERVER}.yml"

# Check if the specific file exists
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Error: No compose file found at '$COMPOSE_FILE'" >&2
  echo "Expected filename: ${SERVER}.yml inside '${SERVERS_DIR}/'" >&2
  exit 1
fi

echo "Using compose file: $COMPOSE_FILE"

# Read environment variables from the local .env file (if it exists in root)
# Adjust path if .env is located elsewhere
if [ -f ".env" ]; then
  set -a
  source .env
  set +a
else
  echo "Warning: No .env file found in $(pwd). Proceeding without substitution." >&2
fi

# Deployment
if [ -n "${1-}" ]; then
  # Remote: Single SSH command with pipe (asks password only once)
  echo "Deploying to $SERVER..."
  envsubst < "$COMPOSE_FILE" | ssh "lab@$SERVER.local" "cat > /home/lab/docker-compose.yml && cd /home/lab && docker compose pull && docker compose up -d --remove-orphans && docker image prune -af && docker compose ps"
else
  # Local
  echo "Deploying locally..."
  envsubst < "$COMPOSE_FILE" > ~/docker-compose.yml
  cd ~
  docker compose pull
  docker compose up -d --remove-orphans
  docker image prune -af
  docker compose ps
fi