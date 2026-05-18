#!/bin/bash

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

if [ ! -f /root/restic_pw ]; then
	echo "The file /root/restic_pw does not exist, exiting..."
	exit 1
fi

echo "--------------------------------"
echo "Starting backup on $(date)"
echo "--------------------------------"

export RESTIC_REPOSITORY="rclone:kDriveSAG:/backups/pollux-server-backup"
export RESTIC_CACHE_DIR="/root/.cache/restic"
export RESTIC_PASSWORD=$(cat /root/restic_pw)
export GOMAXPROCS=4

if [ ! -d $RESTIC_CACHE_DIR ]; then
	mkdir -p "${RESTIC_CACHE_DIR}"
fi

restic unlock
restic backup --tag=automated --pack-size=128 --compression=auto \
	/opt/sag/nextcloud \
	/opt/sag/meteorastronomie.ch
restic check --with-cache --read-data-subset=5G
restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2
restic cache --cleanup
