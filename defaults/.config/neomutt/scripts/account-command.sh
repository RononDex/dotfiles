#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

hostname=""
username=""
accountType=""

while [[ $# -gt 0 ]]; do
	case $1 in
	--hostname)
		hostname="$2"
		shift
		shift
		;;
	--username)
		username="$2"
		shift
		shift
		;;
	--type)
		accountType="$2"
		shift
		shift
		;;
	esac
done

if [[ $hostname == *"mail.hostpoint.ch"* ]] && [ "$username" = "tino.heuberger@sag-sas.ch" ]; then
	decrypted=$(cat $scriptDir/../crypt-store/tino-sag-sas.hostpoint.ch | gpg --for-your-eyes-only --no-tty --quiet --decrypt)
	echo "password: $decrypted"
elif [[ $hostname == *"127.0.0.1"* ]] && [ "$username" = "tinoheuberger@protonmail.com" ]; then
	decrypted=$(cat $scriptDir/../crypt-store/tino-proton | gpg --for-your-eyes-only --no-tty --quiet --decrypt)
	echo "password: $decrypted"
fi
