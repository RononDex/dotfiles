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
				curl -L -o "$extension_path" "$extension_url"
		fi
}

