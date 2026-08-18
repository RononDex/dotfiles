#!/bin/bash

echo "----------------------------"
echo "Updating Authentik"
echo "----------------------------"

cd /opt/sag/authentik

sudo docker compose pull
sudo docker compose build --pull
sudo docker compose up -d --force-recreate
