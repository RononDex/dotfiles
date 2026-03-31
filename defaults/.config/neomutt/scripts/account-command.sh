#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

hostname=""
username=""
type=""

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
		username="$2"
		shift
		shift
		;;
	esac
done

if [[ $hostname == *"mail.hostpoint.ch"* ]] && [ "$username" = "tino.heuberger@sag-sas.ch" ]; then
	decrypted=$(cat $scriptDir/../crypt-store/tino-sag-sas.hostpoint.ch | gpg --quiet --decrypt)
	echo "password: $decrypted"
fi
