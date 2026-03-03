#!/usr/bin/env bash

# Builds all repositories in the correct order with dependency resolution
# Usage: ./scripts_linux/build-all.sh [--skip-tests] [--no-clean]

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

TEST_FLAG=""
CLEAN_PHASE="clean"

for arg in "$@"; do
  case $arg in
    --skip-tests)
      TEST_FLAG="-DskipTests"
      shift
      ;;
    --no-clean)
      CLEAN_PHASE=""
      shift
      ;;
  esac
done

echo -e "\e[36m========================================\e[0m"
echo -e "\e[36m Multi-Repo Build Workflow\e[0m"
echo -e "\e[36m========================================\e[0m"
echo ""

# Step 1: Build and install core-platform
echo -e "\e[33m[1/3] Building core-platform (install to local Maven repo)...\e[0m"
cd "$ROOT_DIR/core-plataform"
./mvnw $CLEAN_PHASE install $TEST_FLAG
echo -e "\e[32m✓ core-platform installed successfully\e[0m"
echo ""

# Step 2: Build iam-service
echo -e "\e[33m[2/3] Building iam-service...\e[0m"
cd "$ROOT_DIR/iam-service"
./mvnw $CLEAN_PHASE verify $TEST_FLAG
echo -e "\e[32m✓ iam-service built successfully\e[0m"
echo ""

# Step 3: Build ai-service
echo -e "\e[33m[3/3] Building ai-service...\e[0m"
cd "$ROOT_DIR/ai-service"
./mvnw $CLEAN_PHASE verify $TEST_FLAG
echo -e "\e[32m✓ ai-service built successfully\e[0m"
echo ""

echo -e "\e[36m========================================\e[0m"
echo -e "\e[32m ✓ ALL BUILDS SUCCESSFUL\e[0m"
echo -e "\e[36m========================================\e[0m"
