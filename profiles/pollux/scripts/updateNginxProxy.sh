#!/bin/bash

echo "----------------------------"
echo "Updating reverse proxy"
echo "----------------------------"

cd /opt/sag/reverse-proxy

sudo docker compose build --pull
sudo docker compose up -d --force-recreate
