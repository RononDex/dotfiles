#!/bin/sh
QUERY="$1"
GROUPS=~/Nextcloud/mail-aliases.conf

# Check if query exactly matches a group name
MATCH=$(grep -i "^$QUERY=" "$GROUPS" | cut -d'=' -f2)

if [ -n "$MATCH" ]; then
	printf "%s\tGroup: %s\n" "$MATCH" "$QUERY"
else
	khard email --parsable --remove-first-line "$QUERY"
fi
