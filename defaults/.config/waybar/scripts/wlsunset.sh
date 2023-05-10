#!/usr/bin/env sh

#Accepts managing parameter
case $1'' in
'off')
    pkill wlsunset
    ;;
'on')
    start
    ;;
'toggle')
    if pkill -0 wlsunset; then
        pkill wlsunset
    else
        wlsunset -l 44 -L 8
    fi
    ;;
'check')
    command -v wlsunset
    exit $?
    ;;
esac

#Returns a string for Waybar
if pkill -0 wlsunset; then
    class="on"
else
    class="off"
fi

printf '{"alt":"%s"}\n' "$class"
