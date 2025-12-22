#!/bin/bash

MODE="$1"

if [ "$MODE" == "up" ]; then
	hyprctl hyprsunset gamma +10
elif [ "$MODE" == "down" ]; then
	hyprctl hyprsunset gamma -10
fi
