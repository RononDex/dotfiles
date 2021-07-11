#!/bin/bash

function readJson {
  UNAMESTR=`uname`
  if [[ "$UNAMESTR" == 'Linux' ]]; then
    SED_EXTENDED='-r'
  elif [[ "$UNAMESTR" == 'Darwin' ]]; then
    SED_EXTENDED='-E'
  fi;

  VALUE=`grep -m 1 "\"${2}\"" ${1} | sed ${SED_EXTENDED} 's/^ *//;s/.*: *"//;s/",?//'`

  if [ ! "$VALUE" ]; then
    echo "Error: Cannot find \"${2}\" in ${1}" >&2;
    exit 1;
  else
    echo $VALUE ;
  fi;
}

wget "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
mv "HPImageArchive.aspx?format=js&idx=0&n=1" /tmp/currentBingImage.json
FILEURL=`node -p "require('/tmp/currentBingImage.json').images[0].url"`
wget "https://bing.com/${FILEURL}"
mv "${FILEURL:1}" /usr/share/backgrounds/bing.jpg
chmod 777 /usr/share/backgrounds/bing.jpg