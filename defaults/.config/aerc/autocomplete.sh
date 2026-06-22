#!/bin/sh
QUERY="$1"
ALIASFILE="$HOME/Nextcloud/mail-aliases.conf"

# Check if query exactly matches a group name
MATCH=$(grep -i "^$QUERY" "$ALIASFILE" | cut -d'=' -f2)

if [ -n "$MATCH" ]; then
	printf "%s\tGroup: %s\n" "$MATCH" "$QUERY"
fi

khard email --parsable --remove-first-line "$QUERY"
