#!/bin/sh
QUERY="$1"
ALIASFILE="$HOME/Nextcloud/mail-aliases.conf"

while IFS='=' read -r name emails; do
	case "$name" in
	$QUERY*) printf "%s\tGroup: %s\tOTHER\n" "$emails" "$name" ;;
	esac
done <"$ALIASFILE"

khard email --parsable --remove-first-line "$QUERY"
