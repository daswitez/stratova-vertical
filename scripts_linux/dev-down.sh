#!/usr/bin/env bash

# Stop and remove Postgres+PGVector containers.
# Usage: ./scripts_linux/dev-down.sh

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AI_SERVICE_DIR="$ROOT_DIR/ai-service"

cd "$AI_SERVICE_DIR"

echo "Stopping Postgres container..."
docker compose down
echo -e "\e[32mContainers stopped and removed.\e[0m"
