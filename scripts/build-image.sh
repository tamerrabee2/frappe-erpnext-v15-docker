#!/bin/bash
# ============================================================
# Script: Build Custom Docker Image
# ERPNext v15 + HRMS + Healthcare (Marley)
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo " Building Custom Frappe Docker Image"
echo "========================================"

cd "$PROJECT_DIR"

# Encode apps.json
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)
echo "[OK] apps.json encoded"

# Build the image
docker build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=frappe-erpnext-custom:v15 \
  --file=Containerfile \
  . \
  --no-cache

echo ""
echo "[SUCCESS] Image built: frappe-erpnext-custom:v15"
echo "Now run: bash scripts/start.sh"
