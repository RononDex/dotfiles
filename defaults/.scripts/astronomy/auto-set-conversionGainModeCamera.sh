#!/bin/bash
# gain_watcher.sh

LAST_FILTER=""

get_current_gain_mode() {
	indi_getprop "ToupTek ATR2600M.TC_CONVERSION_GAIN.GAIN_HIGH" | grep -oP '(?<==).+'
}

set_gain_mode() {
	local target_high=$1 # "On" or "Off"
	local target_low=$2  # "On" or "Off"
	local max_retries=5
	local attempt=0

	while [ $attempt -lt $max_retries ]; do
		indi_setprop "ToupTek ATR2600M.TC_CONVERSION_GAIN.GAIN_LOW=${target_low}"
		indi_setprop "ToupTek ATR2600M.TC_CONVERSION_GAIN.GAIN_HIGH=${target_high}"

		sleep 0.5

		# Verify the value was actually set
		local current=$(get_current_gain_mode)
		if [ "$current" = "$target_high" ]; then
			echo "Gain mode confirmed: GAIN_HIGH=${target_high}"
			return 0
		fi

		attempt=$((attempt + 1))
		echo "Gain mode not set correctly (got GAIN_HIGH=${current}, expected ${target_high}), retrying ($attempt/$max_retries)..."
		sleep 1
	done

	echo "ERROR: Failed to set gain mode after $max_retries attempts"
	return 1
}

while true; do
	# Get current slot number
	SLOT=$(indi_getprop "Atik EFW2.FILTER_SLOT.FILTER_SLOT_VALUE" | grep -oP '(?<==)\d+')

	# Look up filter name from slot number
	FILTER=$(indi_getprop "Atik EFW2.FILTER_NAME.FILTER_SLOT_NAME_${SLOT}" | grep -oP '(?<==).+')

	# Only act if filter has changed
	if [ "$FILTER" != "$LAST_FILTER" ]; then
		echo "Filter changed to: $FILTER (slot $SLOT)"
		case "$FILTER" in
		"Ha" | "SII" | "OIII")
			echo "Setting HCG mode"
			set_gain_mode "On" "Off"
			;;
		"L" | "R" | "G" | "B")
			echo "Setting LCG mode"
			set_gain_mode "Off" "On"
			;;
		*)
			echo "Unknown filter: $FILTER, no gain change applied"
			;;
		esac

		# Only update LAST_FILTER if set_gain_mode succeeded
		if [ $? -eq 0 ]; then
			LAST_FILTER="$FILTER"
		else
			echo "Will retry gain mode set on next poll cycle"
		fi
	else
		# Even if filter hasn't changed, verify gain mode is still correct
		# (catches cases where camera lost its setting unexpectedly)
		case "$FILTER" in
		"Ha" | "SII" | "OIII")
			current=$(get_current_gain_mode)
			if [ "$current" != "On" ]; then
				echo "Gain mode drifted for filter $FILTER, re-applying HCG"
				set_gain_mode "On" "Off"
			fi
			;;
		"L" | "R" | "G" | "B")
			current=$(get_current_gain_mode)
			if [ "$current" != "Off" ]; then
				echo "Gain mode drifted for filter $FILTER, re-applying LCG"
				set_gain_mode "Off" "On"
			fi
			;;
		esac
	fi

	sleep 2
done
