#!/usr/bin/env bash
set -euo pipefail

user=podman-svc
home="/home/$user"

if getent passwd "$user" >/dev/null; then
	exit 0
fi

useradd --system --user-group --create-home --home-dir "$home" \
	--shell /usr/sbin/nologin --add-subids-for-system "$user"

getsubids "$user"
getsubids -g "$user"

runuser -u "$user" -- mkdir -p "$home/.config/containers/systemd"
loginctl enable-linger "$user"
