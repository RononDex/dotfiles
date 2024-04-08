#!/usr/bin/bash
VARSCRIPT="${HOME}/.config/waybar/scripts/wlsunset-temp.sh"

LONGITUDE=8
LATITUDE=44

source $VARSCRIPT

function restart() {
    if pkill -0 wlsunset; then
        pkill wlsunset
        wlsunset -l $LATITUDE -L $LONGITUDE -t $SUNET_TEMP &
    fi
}

#Accepts managing parameter
case $1'' in
'off')
    pkill wlsunset
    ;;
'on')
    start
    ;;

'inc')
    SUNET_TEMP=$((SUNET_TEMP + 100))
	echo "SUNET_TEMP=${SUNET_TEMP}" > $VARSCRIPT
    toggle
	;;
'dec')
    SUNET_TEMP=$((SUNET_TEMP - 100))
	echo "SUNET_TEMP=${SUNET_TEMP}" > $VARSCRIPT
    toggle
	;;
'toggle')
    if pkill -0 wlsunset; then
        pkill wlsunset
    else
        wlsunset -l $LATITUDE -L $LONGITUDE -t $SUNET_TEMP &
    fi
    ;;
'check')
    command -v wlsunset
    exit $?
    ;;
esac

sleep 0.02s
#Returns a string for Waybar
if pkill -0 wlsunset; then
    class=" "
	tooltip="${SUNET_TEMP}K"
else
    class="󰖨 "
	tooltip="off"
fi

printf '{"text":"%s", "tooltip":"%s"}' "$class" "$tooltip"
