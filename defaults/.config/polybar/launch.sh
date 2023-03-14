#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2s; done

sleep 0.2s

# Launch
polybar top &

sleep 0.2s

polybar bottom &

echo "Bars launched..."
