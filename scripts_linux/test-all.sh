#!/usr/bin/env bash

# Runs all tests in all repositories
# Ensures core-platform is installed first
# Usage: ./scripts_linux/test-all.sh

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "\e[36m========================================\e[0m"
echo -e "\e[36m Running All Tests\e[0m"
echo -e "\e[36m========================================\e[0m"
echo ""

# Step 1: Install core-platform
echo -e "\e[33m[0/3] Installing core-platform...\e[0m"
"$SCRIPT_DIR/install-core.sh"
echo ""

# Step 2: Test core-platform
echo -e "\e[33m[1/3] Testing core-platform...\e[0m"
cd "$ROOT_DIR/core-plataform"
./mvnw test
echo -e "\e[32m✓ core-platform tests passed\e[0m"
echo ""

# Step 3: Test iam-service
echo -e "\e[33m[2/3] Testing iam-service...\e[0m"
cd "$ROOT_DIR/iam-service"
./mvnw test
echo -e "\e[32m✓ iam-service tests passed\e[0m"
echo ""

# Step 4: Test ai-service
echo -e "\e[33m[3/3] Testing ai-service...\e[0m"
cd "$ROOT_DIR/ai-service"
./mvnw test
echo -e "\e[32m✓ ai-service tests passed\e[0m"
echo ""

echo -e "\e[36m========================================\e[0m"
echo -e "\e[32m ✓ ALL TESTS PASSED\e[0m"
echo -e "\e[36m========================================\e[0m"
