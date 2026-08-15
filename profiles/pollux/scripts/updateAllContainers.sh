#!/bin/bash
mkdir -p /root/logs
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/root/logs/updateAllContainers.log 2>&1

bash /root/scripts/updateMeteorastronomie.sh
bash /root/scripts/updateUptimeKuma.sh
bash /root/scripts/updateNextcloud.sh
bash /root/scripts/updateNginxProxy.sh
