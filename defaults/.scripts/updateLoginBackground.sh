#!/bin/bash

function readJson {
	UNAMESTR=$(uname)
	if [[ "$UNAMESTR" == 'Linux' ]]; then
		SED_EXTENDED='-r'
	elif [[ "$UNAMESTR" == 'Darwin' ]]; then
		SED_EXTENDED='-E'
	fi

	VALUE=$(grep -m 1 "\"${2}\"" ${1} | sed ${SED_EXTENDED} 's/^ *//;s/.*: *"//;s/",?//')

	if [ ! "$VALUE" ]; then
		echo "Error: Cannot find \"${2}\" in ${1}" >&2
		exit 1
	else
		echo $VALUE
	fi
}

wget "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&uhd=1"
mv "HPImageArchive.aspx?format=js&idx=0&n=1&uhd=1" /tmp/currentBingImage.json
FILEURL=$(node -p "require('/tmp/currentBingImage.json').images[0].urlbase")
wget "https://bing.com/${FILEURL}_UHD.jpg"
cp "${FILEURL:1}_UHD.jpg" /usr/share/sddm/themes/silent/backgrounds/bing.jpg
rm "${FILEURL:1}_UHD.jpg"
