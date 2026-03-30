#!/bin/bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} -iregex '.*.\\(jpg\\|jpeg\\|png\\|gif\\)' -type f | shuf -n 1) # select random backgroundImage
mkdir -p ~/.cache/wal
echo $backgroundImage >~/.cache/wal/bgImage

awww img $(cat ~/.cache/wal/bgImage) &
