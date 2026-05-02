#!/bin/bash
set -euo pipefail

mailBox=$1
pass_phrase="$(cat /etc/hostname):$(cat /etc/machine-id)"

exec gpg \
	--batch \
	--yes \
	--pinentry-mode loopback \
	--passphrase "$pass_phrase" \
	--no-tty \
	--quiet \
	--decrypt "$HOME/.config/neomutt/crypt-store/$mailBox" \
	2>/dev/null
