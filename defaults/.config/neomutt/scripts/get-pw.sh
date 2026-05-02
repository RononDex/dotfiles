#!/bin/bash

mailBox=$1
gpg --for-your-eyes-only --pinentry-mode loopback --passphrase "$(cat /etc/hostname):$(cat /etc/machine-id)" --no-tty --quiet --decrypt ~/.config/neomutt/crypt-store/$1
