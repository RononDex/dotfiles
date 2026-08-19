#!/bin/bash
mkdir -p /root/logs
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/root/logs/updateAllContainers.log 2>&1

echo "--------------------------------------------"
echo " Updating all containers at $(date)"
echo "--------------------------------------------"

bash /root/scripts/updateMeteorastronomie.sh

sleep 60s

bash /root/scripts/updateUptimeKuma.sh

sleep 60s

bash /root/scripts/authentik.sh

sleep 60s

bash /root/scripts/updateNextcloud.sh

sleep 60s

bash /root/scripts/updateNginxProxy.sh
