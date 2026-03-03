#!/usr/bin/env bash

# This script installs the core-platform to the local Maven repository
# Usage: ./scripts_linux/install-core.sh [--test]

set -e # Exit on error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

SKIP_TESTS="-DskipTests"
if [ "$1" == "--test" ]; then
    SKIP_TESTS=""
fi

echo -e "\e[33mInstalling core-platform to local Maven repo...\e[0m"

cd "$ROOT_DIR/core-plataform"

./mvnw clean install $SKIP_TESTS

echo -e "\e[32m✓ core-platform installed successfully\e[0m"
