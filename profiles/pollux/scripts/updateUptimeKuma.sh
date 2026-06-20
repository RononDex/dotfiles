echo "----------------------------"
echo "Updating Kuma Uptime tracker"
echo "----------------------------"

cd /opt/sag/uptime-kuma

sudo docker compose down
sudo docker compose build --pull
sudo docker compose up -d
