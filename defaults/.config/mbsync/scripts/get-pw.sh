#!/bin/bash

mailBox=$1
gpg \
	--for-your-eyes-only \
	--pinentry-mode loopback \
	--default-key MachineKey \
	--passphrase "$(cat /etc/hostname):$(cat /etc/machine-id)" \
	--no-tty \
	--quiet \
	--decrypt ~/.config/mbsync/crypt-store/$mailBox
