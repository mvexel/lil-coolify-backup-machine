This is a repo that you can use to create a tiny coolify app to backup your coolify-managed docker volumes offsite (S3 or R2 or compat).

0. Create a new Coolify app based on this repo
1. mount host `/mnt/wherever/your/docker/volumes/live` → container /data:ro.
2. Add env vars to app
    - `S3_ENDPOINT`
    - `S3_ACCESS_KEY_ID`
    - `S3_SECRET_ACCESS_KEY`
    - `S3_BUCKET`
3. Create scheduled task e.g. `0 3 * * *`: `/usr/local/bin/backup.sh`