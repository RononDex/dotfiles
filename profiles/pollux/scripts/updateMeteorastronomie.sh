echo "----------------------------"
echo "Updating Meteorastronomie Db"
echo "----------------------------"

cd /opt/sag/meteorastronomie.ch

sudo docker compose down
sudo docker compose build --pull
sudo docker compose up -d
