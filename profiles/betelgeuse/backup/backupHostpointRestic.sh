#!/bin/bash
set -euo pipefail

HOSTPOINT_MOUNT=/home/backup-svc/hostpoint-mnt
RESTIC_PW_FILE=/home/backup-svc/crypt-store/restic-pw-hostpoint

# Ensure no other backup process is running
if pgrep -f "restic backup" >/dev/null; then
	echo "Restic is already running..." 1>&2
	exit 1
fi

if [ ! -f $RESTIC_PW_FILE ]; then
	echo "The file $RESTIC_PW_FILE does not exist, exiting..."
	exit 1
fi

echo "--------------------------------"
echo "Starting Hostpoint backup on $(date)"
echo "--------------------------------"

echo "Mounting Hostpoint through sshfs..."
sshfs -o ro,compression=yes hostpoint-sag: $HOSTPOINT_MOUNT
trap 'fusermount3 -u -- "$HOSTPOINT_MOUNT"' EXIT

export RCLONE_PASSWORD_COMMAND='/usr/bin/cat /home/backup-svc/crypt-store/rclone-pw'
export RESTIC_REPOSITORY="rclone:kDriveSAG:/backups/hostpoint-backup"
export RESTIC_PASSWORD_FILE=$RESTIC_PW_FILE
export GOMAXPROCS=4

restic unlock
restic backup --tag=automated --pack-size=128 --compression=auto --ignore-inode=true \
	$HOSTPOINT_MOUNT/www \
	$HOSTPOINT_MOUNT/www-inaktiv \
	$HOSTPOINT_MOUNT/scripts \
	$HOSTPOINT_MOUNT/db-dumps

restic check --with-cache --read-data-subset=5G
restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2
restic cache --cleanup

PUSH_URL=$(cat /home/backups-svc/push-urls/hostpoint-backup)
curl -fsS --max-time 30 -o /dev/null -- "$PUSH_URL"
