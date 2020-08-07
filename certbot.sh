#!/bin/sh
echo "Making sure server is down"
sudo -E docker-compose down -v
sudo -E docker-compose -f docker-compose.prod.yml down -v

echo "Creating folder structure"
mkdir -p ".data/certbot/challenge"
mkdir -p ".data/certbot/etc"
mkdir -p ".data/certbot/var"
mkdir -p ".data/certbot/log"
mkdir -p ".data/dhparam/"
export FOLDER_PATH=.data/certbot/etc/live/certificates
sudo mkdir -p "$FOLDER_PATH"

echo "Creating fake certificates so nginx can run"
sudo openssl req -x509 -nodes -newkey rsa:4096 -days 1 -keyout "$FOLDER_PATH/privkey.pem" -out "$FOLDER_PATH/fullchain.pem" -subj "/CN=localhost"
sudo openssl dhparam -out ./.data/dhparam/dhparam-4096.pem 4096

echo "Start the services"
sudo -E docker-compose -f docker-compose.yml up -d

echo "Deleting the fake certificates"
sudo rm -rfv .data/certbot/etc/*

echo "Restarting certbot so that in can generate genuine ones"
sudo -E docker-compose -f docker-compose.prod.yml up -d --force-recreate --no-deps certbot
echo "Restarting nginx so it can load the certificates."
sudo -E docker-compose -f docker-compose.prod.yml up -d --force-recreate --no-deps nginx