#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1s; done

sleep 0.3s

# Launch
polybar top &
polybar bottom &

echo "Bars launched..."
