#!/bin/bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} -type f | shuf -n 1) # select random backgroundImage
mkdir -p ~/.cache/wal
echo $backgroundImage >~/.cache/wal/bgImage

wallust run $(cat ~/.cache/wal/bgImage)
awww img $(cat ~/.cache/wal/bgImage) --transition-type right
