#!/bin/bash
set -uo pipefail

cd $1
git pull
sh profile-enabler $2
