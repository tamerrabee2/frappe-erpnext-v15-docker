#!/bin/bash
# ============================================================
# Script: Start Docker Stack
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "Starting ERPNext stack..."
docker compose up -d

echo ""
echo "[OK] Stack started. Waiting 15 seconds for services to be ready..."
sleep 15

docker compose ps
echo ""
echo "Site will be available at: http://localhost:8080"
