#!/bin/bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} | shuf -n 1) # select random backgroundImage
echo $backgroundImage > ~/.cache/wal/bgImage

wal -i $(cat ~/.cache/wal/bgImage) &
pkill swaybg
sleep 0.1s
swaybg -i $backgroundImage &
