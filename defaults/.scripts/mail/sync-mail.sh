#!/bin/sh
set -e

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

CHANNEL=$1
MBSYNC=$(pgrep mbsync || true)
NOTMUCH=$(pgrep notmuch || true)

if [ -n "$MBSYNC" -o -n "$NOTMUCH" ]; then
	echo "Already running one instance of mbsync or notmuch. Exiting..."
	exit 0
fi

echo "Syncing with vdirsyncer ..."
vdirsyncer sync

echo "Deleting messages tagged as *deleted*"
notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm -v

mbsync -a

notmuch new
