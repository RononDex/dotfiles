#!/bin/bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} -type f | shuf -n 1) # select random backgroundImage
mkdir -p ~/.cache/wal
echo $backgroundImage > ~/.cache/wal/bgImage

pkill wal
sleep 0.05s
wal -i $(cat ~/.cache/wal/bgImage) &
pkill swaybg
sleep 0.1s
swaybg -i $backgroundImage -m fill &
