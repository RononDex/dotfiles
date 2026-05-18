#!/bin/bash

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

sudo rm -rf /root/scripts
sudo cp -r $scriptDir/scripts /root/scripts
