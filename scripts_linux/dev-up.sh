#!/usr/bin/env bash

# Start Postgres+PGVector via Docker Compose and wait for healthcheck.
# Usage: ./scripts_linux/dev-up.sh

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AI_SERVICE_DIR="$ROOT_DIR/ai-service"

cd "$AI_SERVICE_DIR"

echo "Starting Postgres container..."
docker compose up -d

CID=$(docker compose ps -q postgres 2>/dev/null || true)
if [ -z "$CID" ]; then
    echo "Error: Postgres container not found. Check docker compose up."
    exit 1
fi

MAX_ATTEMPTS=60
ATTEMP=0

echo "Waiting for Postgres to be healthy..."
while true; do
    STATUS=$(docker inspect --format '{{.State.Health.Status}}' "$CID" 2>/dev/null || echo "unknown")
    
    if [ "$STATUS" == "healthy" ]; then
        echo -e "\e[32mPostgres is healthy.\e[0m"
        exit 0
    fi
    
    ATTEMP=$((ATTEMP+1))
    if [ "$ATTEMP" -ge "$MAX_ATTEMPTS" ]; then
        echo -e "\e[31mError: Healthcheck did not pass within timeout.\e[0m"
        exit 1
    fi
    
    sleep 2
done
