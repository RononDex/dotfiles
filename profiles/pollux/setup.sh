#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

sudo rm -rf /root/scripts
sudo cp -r $scriptDir/scripts /root/scripts

sudo chmod -R +x /root/scripts/
sudo cp $scriptDir/systemD/restic-backup.service /etc/systemd/system/restic-backup.service
sudo cp $scriptDir/systemD/restic-backup.timer /etc/systemd/system/restic-backup.timer
