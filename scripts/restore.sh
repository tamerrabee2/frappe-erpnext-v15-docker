#!/bin/bash
# ============================================================
# Script: Restore site from backup
# Usage: bash scripts/restore.sh site1.local /path/to/backup.sql.gz /path/to/files.tar.gz
# ============================================================

SITE_NAME=${1:-site1.local}
DB_BACKUP=$2
FILES_BACKUP=$3
DB_ROOT_PASS=${MARIADB_ROOT_PASSWORD:-changeme_root_password}

if [ -z "$DB_BACKUP" ]; then
  echo "Usage: bash restore.sh <site_name> <db_backup.sql.gz> [files_backup.tar.gz]"
  exit 1
fi

echo "Restoring site: $SITE_NAME"

# Copy backup files into container
docker cp "$DB_BACKUP" frappe_backend:/home/frappe/frappe-bench/
[ -n "$FILES_BACKUP" ] && docker cp "$FILES_BACKUP" frappe_backend:/home/frappe/frappe-bench/

# Restore
FILES_ARG=""
[ -n "$FILES_BACKUP" ] && FILES_ARG="--with-public-files /home/frappe/frappe-bench/$(basename $FILES_BACKUP)"

docker exec -it frappe_backend bench --site "$SITE_NAME" \
  restore "/home/frappe/frappe-bench/$(basename $DB_BACKUP)" \
  --mariadb-root-password "$DB_ROOT_PASS" \
  $FILES_ARG

docker exec -it frappe_backend bench --site "$SITE_NAME" migrate
docker exec -it frappe_backend bench --site "$SITE_NAME" clear-cache

echo "[SUCCESS] Restore completed for $SITE_NAME"
