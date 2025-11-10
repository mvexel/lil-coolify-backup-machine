#!/usr/bin/env bash
set -euo pipefail
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="coolify-volumes-backup-$DATE.tar.gz"
BUCKET="${S3_BUCKET}"
REMOTE=":s3,rclonetype=s3,provider=Cloudflare,env_auth=false,access_key_id=${S3_ACCESS_KEY_ID},secret_access_key=${S3_SECRET_ACCESS_KEY},endpoint=${S3_ENDPOINT}"

# stream volumes -> R2
tar -czf - -C /data volumes \
  | rclone rcat "${REMOTE}${BUCKET}/${BACKUP_NAME}" --s3-no-check-bucket

# retention
rclone delete "${REMOTE}${BUCKET}" --min-age 30d --s3-no-check-bucket
