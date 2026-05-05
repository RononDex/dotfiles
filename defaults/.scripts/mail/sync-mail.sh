#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

CHANNEL=$1
MBSYNC=$(pgrep mbsync)
NOTMUCH=$(pgrep notmuch)

if [ -n "$MBSYNC" -o -n "$NOTMUCH" ]; then
	echo "Already running one instance of mbsync or notmuch. Exiting..."
	exit 0
fi

echo "Deleting messages tagged as *deleted*"
notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm -v

mbsync $CHANNEL

# capture new messages before notmuch new runs (and triggers post-new hook)
before=$(notmuch count tag:unread and tag:inbox)

notmuch new

after=$(notmuch count tag:unread and tag:inbox)

if [[ "$after" -gt "$before" ]]; then
	count=$((after - before))
	# query the most recent unread messages
	notmuch search --format=text --output=summary \
		--limit="$count" "tag:unread and tag:inbox" |
		while read -r line; do
			sender=$(echo "$line" | grep -oP '(?<=\] ).*?(?=;)')
			subject=$(echo "$line" | grep -oP '(?<=; ).*?(?= \()')
			notify-send --app-name "New Mail" "$sender:" "$subject"
		done
fi
