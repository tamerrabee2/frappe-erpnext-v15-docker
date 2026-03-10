#!/bin/bash
# ============================================================
# Script: Create New Site inside running Docker stack
# Usage: bash scripts/new-site.sh site1.local
# ============================================================

set -e

SITE_NAME=${1:-site1.local}
DB_ROOT_PASS=${MARIADB_ROOT_PASSWORD:-changeme_root_password}
ADMIN_PASS=${ADMIN_PASSWORD:-changeme_admin_password}

echo "Creating site: $SITE_NAME"

docker exec -it frappe_backend \
  bench new-site "$SITE_NAME" \
  --mariadb-root-password "$DB_ROOT_PASS" \
  --admin-password "$ADMIN_PASS"

echo "[OK] Site created. Installing apps..."

docker exec -it frappe_backend bench --site "$SITE_NAME" install-app erpnext
docker exec -it frappe_backend bench --site "$SITE_NAME" install-app payments
docker exec -it frappe_backend bench --site "$SITE_NAME" install-app hrms
docker exec -it frappe_backend bench --site "$SITE_NAME" install-app healthcare

echo ""
docker exec -it frappe_backend bench --site "$SITE_NAME" list-apps

echo ""
echo "[SUCCESS] $SITE_NAME is ready!"
echo "Open: http://localhost:8080"
