#!/bin/bash
set -euo pipefail

cd $1
git pull
sh profile-enabler $2
