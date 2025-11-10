FROM alpine:3.20
RUN apk add --no-cache bash tar rclone ca-certificates
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh
CMD ["sleep","infinity"]  # stay awake
