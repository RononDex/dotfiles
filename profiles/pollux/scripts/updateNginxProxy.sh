echo "----------------------------"
echo "Updating reverse proxy"
echo "----------------------------"

cd /opt/sag/reverse-proxy

sudo docker compose down
sudo docker compose build --pull
sudo docker compose up -d
