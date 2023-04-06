#!/bin/bash

SIGRTMIN=34
pid_of_wvkbd=$(pidof wvkbd-mobintl)
kill -n $SIGRTMIN $pid_of_wvkbd
