#!/usr/bin/env bash
set -euo pipefail

# Fail fast if something is missing
: "${S3_ENDPOINT:?set in Coolify env}"
: "${S3_ACCESS_KEY_ID:?set in Coolify env}"
: "${S3_SECRET_ACCESS_KEY:?set in Coolify env}"
: "${S3_BUCKET:?set in Coolify env}"

if [ ! -d /data/volumes ]; then
  echo "ERROR: /data/volumes not found. Mount /mnt/coolify-data -> /data in Coolify." >&2
  exit 1
fi

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="coolify-volumes-backup-$DATE.tar.gz"

REMOTE=":s3,provider=Cloudflare,env_auth=false,access_key_id=${S3_ACCESS_KEY_ID},secret_access_key=${S3_SECRET_ACCESS_KEY},endpoint=${S3_ENDPOINT}:"

# Stream to R2 and keep retention
tar -czf - -C /data volumes \
  | rclone rcat "${REMOTE}${S3_BUCKET}/${BACKUP_NAME}" --s3-no-check-bucket

rclone delete "${REMOTE}${S3_BUCKET}" --min-age 30d --s3-no-check-bucket
