#!/usr/bin/env bash
kitty -T MainTerminal &
kitty -T htop -e htop &
kitty -T ranger -e ranger &
kitty -T cava -e cava &

ckb-next -b &
nextcloud &
redshift &
