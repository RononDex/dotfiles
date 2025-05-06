#!/bin/bash

function InstallFirefoxExtension() {
		# $1: extension-id
		# $2: extension-url for download
		# $3: profile-dir
		extension_id=$1
		extension_url=$2
		profile_dir=$3

		if [ ! -d "$profile_dir/extensions" ]; then
				mkdir $profile_dir/extensions
		fi

		extension_path="$profile_dir/extensions/$extension_id.xpi"

		if [ ! -f $extension_path ]; then
				
		fi
}

# === Configuration ===
EXTENSION_URL="https://addons.mozilla.org/firefox/downloads/file/4213060/ublock_origin-latest.xpi"  # example: uBlock Origin
EXTENSION_ID="uBlock0@raymondhill.net"  # must match the extension's manifest.json

# === Step 1: Create a new Firefox profile (if it doesn't exist) ===
PROFILE_DIR=$(mktemp -d -t firefox-profile-XXXX)
echo "Creating Firefox profile in: $PROFILE_DIR"


# === Step 2: Create extensions directory ===
mkdir -p "$PROFILE_DIR/extensions"

# === Step 3: Download the extension ===
EXTENSION_PATH="$PROFILE_DIR/extensions/$EXTENSION_ID.xpi"
echo "Downloading extension to $EXTENSION_PATH"
curl -L -o "$EXTENSION_PATH" "$EXTENSION_URL"

# === Step 4: Launch Firefox with the custom profile ===
echo "Launching Firefox with the profile..."
$FIREFOX_BIN -no-remote -profile "$PROFILE_DIR"

# === Optional: Persist profile location ===
echo "Profile setup complete. Stored at: $PROFILE_DIR"
