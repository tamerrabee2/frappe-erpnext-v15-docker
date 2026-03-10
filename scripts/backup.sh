#!/bin/bash
# ============================================================
# Script: Backup site
# Usage: bash scripts/backup.sh site1.local
# ============================================================

SITE_NAME=${1:-site1.local}

echo "Taking backup for: $SITE_NAME"

docker exec -it frappe_backend \
  bench --site "$SITE_NAME" backup --with-files

echo "[OK] Backup completed. Files are in sites/$SITE_NAME/private/backups/"
