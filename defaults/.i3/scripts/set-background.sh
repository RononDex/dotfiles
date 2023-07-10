#!/bin/bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} -type f | shuf -n 1) # select random backgroundImage
echo $backgroundImage
wal -i $backgroundImage --saturate 0.75
