#!/bin/bash
set -euo pipefail

RESTIC_PW_FILE=/home/backup-svc/crypt-store/restic-pw-betelgeuse

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
echo "Starting backup on $(date)"
echo "--------------------------------"

export RCLONE_PASSWORD_COMMAND='/usr/bin/cat /home/backup-svc/crypt-store/rclone-pw'
export RESTIC_REPOSITORY="rclone:kDriveSAG:/backups/root-server"
export RESTIC_PASSWORD_FILE=$RESTIC_PW_FILE
export GOMAXPROCS=4

if [ ! -d $RESTIC_CACHE_DIR ]; then
	mkdir -p "${RESTIC_CACHE_DIR}"
fi

restic unlock
restic backup --tag=automated --pack-size=128 --compression=auto \
	/srv/data/podman-containers \
	/srv/data/podman-volumes
restic check --with-cache --read-data-subset=5G
restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 2
restic cache --cleanup

PUSH_URL=$(cat /home/backup-svc/push-urls/root-server-backup)
curl -fsS --max-time 30 -o /dev/null -- "$PUSH_URL"
