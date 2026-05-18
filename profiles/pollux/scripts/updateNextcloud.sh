# update

echo "----------------------------"
echo "Update Nextcloud"
echo "----------------------------"

cd /opt/sag/nextcloud

sudo docker compose down
sudo docker compose build --pull
sudo docker compose up -d

echo "Waiting for containers to be online"
sleep 30s

docker exec --user www-data nextcloud-app-1 /var/www/html/occ upgrade
docker exec --user www-data nextcloud-app-1 /var/www/html/occ maintenance:repair --include-expensive
docker exec --user www-data nextcloud-app-1 /var/www/html/occ db:add-missing-indices

echo "----------------------------"
echo "Updating reverse proxy"
echo "----------------------------"

cd /opt/sag/reverse-proxy

sudo docker compose down
sudo docker compose build --pull
sudo docker compose up -d
