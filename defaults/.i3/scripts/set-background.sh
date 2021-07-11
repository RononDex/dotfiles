#!/usr/bin/env bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} | shuf -n 1) # select random backgroundImage
echo $backgroundImage
wal -i $backgroundImage --saturate 0.75
