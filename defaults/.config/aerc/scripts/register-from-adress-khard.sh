#!/usr/bin/env bash

set -euo pipefail

tmp="$(mktemp)"

# read raw mail from stdin
cat >"$tmp"

# extract From header
from="$(sed -n '/^From:/{
    s/^From:[[:space:]]*//
    p
    q
}' "$tmp")"

# extract display name and email
email="$(printf '%s\n' "$from" |
	grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+' |
	head -n1)"

name="$(printf '%s\n' "$from" |
	sed -E 's/[[:space:]]*<.*//' |
	sed -E 's/^"//; s/"$//')"

if [ -z "$email" ]; then
	echo "no email found" >&2
	rm -f "$tmp"
	exit 1
fi

vcf="$(mktemp --suffix=.vcf)"

cat >"$vcf" <<EOF
BEGIN:VCARD
VERSION:3.0
FN:${name}
EMAIL:${email}
END:VCARD
EOF

khard import "$vcf"

rm -f "$tmp" "$vcf"
