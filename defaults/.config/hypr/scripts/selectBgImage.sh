#!/bin/bash

wallpapersDir="${HOME}/wallpapers/"
backgroundImage=$(find ${wallpapersDir} | shuf -n 1) # select random backgroundImage
echo $backgroundImage > ~/.cache/wal/bgImage
