#!/usr/bin/env bash
set -euo pipefail

: "${S3_ENDPOINT:?missing}"
: "${S3_ACCESS_KEY_ID:?missing}"
: "${S3_SECRET_ACCESS_KEY:?missing}"
: "${S3_BUCKET:?missing}"

if [ ! -d /data/volumes ]; then
  echo "ERROR: /data/volumes not found (mount host /mnt/coolify-data -> /data)." >&2
  exit 1
fi

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="coolify-volumes-backup-$DATE.tar.gz"

tar -czf - -C /data volumes \
| rclone rcat "s3:${S3_BUCKET}/${BACKUP_NAME}" \
    --s3-provider Cloudflare \
    --s3-endpoint "${S3_ENDPOINT}" \
    --s3-access-key-id "${S3_ACCESS_KEY_ID}" \
    --s3-secret-access-key "${S3_SECRET_ACCESS_KEY}" \
    --s3-no-check-bucket \
    --s3-force-path-style

# Retention
rclone delete "s3:${S3_BUCKET}" \
    --s3-provider Cloudflare \
    --s3-endpoint "${S3_ENDPOINT}" \
    --s3-access-key-id "${S3_ACCESS_KEY_ID}" \
    --s3-secret-access-key "${S3_SECRET_ACCESS_KEY}" \
    --s3-no-check-bucket \
    --s3-force-path-style \
    --min-age 30d
