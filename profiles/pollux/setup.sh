#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

sudo apt install sshfs restic rclone

sudo rm -rf /root/scripts

sudo cp -r $scriptDir/scripts /root/scripts
sudo chmod -R +x /root/scripts/

sudo cp -r $scriptDir/.ssh /root/.ssh
sudo chmod -R 700 /root/.ssh

sudo cp $scriptDir/systemD/restic-backup.service /etc/systemd/system/restic-backup.service
sudo cp $scriptDir/systemD/restic-backup.timer /etc/systemd/system/restic-backup.timer

sudo cp $scriptDir/systemD/hostpoint-backup.service /etc/systemd/system/hostpoint-backup.service
sudo cp $scriptDir/systemD/hostpoint-backup.timer /etc/systemd/system/hostpoint-backup.timer

bash $scriptDir/updateNextcloud.sh
bash $scriptDir/updateNginxProxy.sh
bash $scriptDir/updateUptimeKuma.sh
bash $scriptDir/updateMeteorastronomie.sh
