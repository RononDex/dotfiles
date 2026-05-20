#!/bin/bash

HOSTPOINT_MOUNT=/root/hostpoint-mnt

# Check if running as root
if [ "$EUID" -ne 0 ]; then
	echo "Please run this script as root" 1>&2
	exit 1
fi

# Ensure no other backup process is running
if pgrep -f "restic backup" >/dev/null; then
	echo "Restic is already running..." 1>&2
	exit 1
fi

if [ ! -f /root/restic_pw_hostpoint ]; then
	echo "The file /root/restic_pw_hostpoint does not exist, exiting..."
	exit 1
fi

echo "--------------------------------"
echo "Starting Hostpoint backup on $(date)"
echo "--------------------------------"

echo "Mounting Hostpoint through rclone..."
rclone mount HostpointSagSas: $HOSTPOINT_MOUNT &

export RESTIC_REPOSITORY="rclone:kDriveSAG:/backups/hostpoint-backup"
export RESTIC_CACHE_DIR="/root/.cache/restic-hostpoint"
export RESTIC_PASSWORD=$(cat /root/restic_pw_hostpoint)
export GOMAXPROCS=4

restic unlock
restic backup --tag=automated --pack-size=128 --compression=auto \
	$HOSTPOINT_MOUNT/www \
	$HOSTPOINT_MOUNT/www-inaktiv \
	$HOSTPOINT_MOUNT/scripts \
	$HOSTPOINT_MOUNT/db-dumps

restic check --with-cache --read-data-subset=5G
restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2
restic cache --cleanup

echo "Unmounting Hostpoint..."
umount /root/hostpoint-mnt
