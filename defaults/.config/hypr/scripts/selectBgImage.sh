#!/bin/bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} -type f | shuf -n 1) # select random backgroundImage
mkdir -p ~/.cache/wal
echo $backgroundImage >~/.cache/wal/bgImage

wallust run $(cat ~/.cache/wal/bgImage) -s
awww img $(cat ~/.cache/wal/bgImage) --transition-type wipe --transition-angle 30 --transition-fps 60
kill -SIGUSR1 $(pgrep kitty)
