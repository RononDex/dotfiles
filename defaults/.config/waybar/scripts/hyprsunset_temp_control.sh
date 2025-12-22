#!/bin/bash

MODE="$1"

if [ "$MODE" == "up" ]; then
	hyprctl hyprsunset temperature +200
elif [ "$MODE" == "down" ]; then
	hyprctl hyprsunset temperature -200
fi
