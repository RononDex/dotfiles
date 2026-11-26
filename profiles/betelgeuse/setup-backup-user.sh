#!/usr/bin/env bash
set -euo pipefail

user=backup-svc
home="/home/$user"

if getent passwd "$user" >/dev/null; then
	exit 0
fi

useradd --system --user-group --create-home --home-dir "$home" \
	--shell /usr/sbin/nologin "$user"
