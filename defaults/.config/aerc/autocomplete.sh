#!/bin/sh
QUERY="$1"

# Check if query matches a khard category exactly
GROUP=$(khard email --remove-first-line --parsable --search-in-source-files "$QUERY" 2>/dev/null)

COUNT=$(echo "$GROUP" | wc -l)

if [ "$COUNT" -gt 1 ]; then
	# Output group as a single selectable line
	EMAILS=$(echo "$GROUP" | awk '{print $1}' | tr '\n' ',' | sed 's/,$//')
	echo "$EMAILS\tGroup: $QUERY"
else
	# Normal single address lookup
	khard email --parsable --remove-first-line "$QUERY"
fi
