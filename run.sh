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

# Function to execute remote commands securely
run_remote() {
  local target_server="$1"
  local temp_file="$2"
  
  echo "Deploying to ${target_server}..."
  
  # 1. Securely copy the substituted file
  scp "$temp_file" "lab@${target_server}.local:/home/lab/docker-compose.yml"
  
  # 2. Execute commands via SSH using a here-document to avoid injection
  ssh "lab@${target_server}.local" bash -s << 'EOF'
    set -euo pipefail
    cd /home/lab
    # Ensure secure permissions
    chmod 600 docker-compose.yml
    docker compose pull
    docker compose up -d --remove-orphans
    docker image prune -af
    docker compose ps
EOF
}

# Generate substituted content to a temporary file
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

if command -v envsubst &> /dev/null; then
  envsubst < "$COMPOSE_FILE" > "$TEMP_FILE"
else
  # Fallback if envsubst is missing (just copy)
  cp "$COMPOSE_FILE" "$TEMP_FILE"
fi

# Deployment Logic
if [ -n "${1-}" ]; then
  # Argument provided: Deploy to remote server
  run_remote "$SERVER" "$TEMP_FILE"
else
  # No argument: Deploy locally (to user home)
  echo "No server argument provided. Deploying locally to ~/docker-compose.yml"
  cp "$TEMP_FILE" ~/docker-compose.yml
  chmod 600 ~/docker-compose.yml
  
  cd ~
  docker compose pull
  docker compose up -d --remove-orphans
  docker image prune -af
  docker compose ps
fi