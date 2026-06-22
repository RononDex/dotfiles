#!/bin/sh
mailAdresses=$(khard email --parsable --remove-first-line $1 | awk -F'\t' 'NR>1 {print $1}' | paste -sd,)
aerc :header To "$mailAdresses"
