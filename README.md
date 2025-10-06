# Backup & Monitor - Simple DevOps Project

Simple bash-based backup + retention and a lightweight load/memory monitor.

## Files
- backup.sh : create tar.gz of selected paths and rotate old backups
- monitor.sh: checks load vs CPU cores and memory usage, logs alerts

## Usage
1. Edit variables in scripts (BACKUP_SRC, BACKUP_DEST, thresholds)
2. `chmod +x backup.sh monitor.sh`
3. Test manually: `./backup.sh`  `./monitor.sh`
4. Add to crontab for automation

