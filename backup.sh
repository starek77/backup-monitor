#!/usr/bin/env bash
set -euo pipefail

# -------------------------
# Simple Backup + Rotation
# -------------------------
# Edit these variables as needed
BACKUP_SRC="/etc /home"        
BACKUP_DEST="$HOME/backups"    
RETENTION_DAYS=7               
LOGFILE="$BACKUP_DEST/backup.log"

mkdir -p "$BACKUP_DEST"

DATE=$(date +%F_%H-%M-%S)
TARFILE="$BACKUP_DEST/backup-$DATE.tar.gz"

echo "$(date '+%F %T') Starting backup..." >> "$LOGFILE"

# Create archive (exclude /proc /sys /dev if accidentally included)
tar --exclude=/proc --exclude=/sys --exclude=/dev -czf "$TARFILE" $BACKUP_SRC 2>>"$LOGFILE" || {
  echo "$(date '+%F %T') ERROR: tar failed" >> "$LOGFILE"
    exit 1
    }

    echo "$(date '+%F %T') Backup created: $TARFILE" >> "$LOGFILE"

    # Remove old backups
    find "$BACKUP_DEST" -type f -name "backup-*.tar.gz" -mtime +"$RETENTION_DAYS" -print -exec rm -f {} \; >> "$LOGFILE" 2>&1 || true

    echo "$(date '+%F %T') Cleanup done. Retention: ${RETENTION_DAYS} days" >> "$LOGFILE"
