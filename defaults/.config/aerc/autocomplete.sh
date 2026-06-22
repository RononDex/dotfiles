#!/bin/sh
QUERY="$1"
GROUPS=~/.config/aerc/groups

# Find all groups starting with the query
while IFS='=' read -r name emails; do
	case "$name" in
	$QUERY*) printf "%s\tGroup: %s\n" "$emails" "$name" ;;
	esac
done <"$GROUPS"

# Also do normal khard lookup
khard email --parsable "$QUERY"
