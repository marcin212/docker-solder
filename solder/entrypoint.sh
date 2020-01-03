#!/bin/sh

printf "\n\033[1mWaiting for postgres to start\033[0m\n"
while ! nc -z "$POSTGRES_HOST" "$POSTGRES_PORT"; do
  sleep 1
done
printf "PostgreSQL started\n\n"

repoUrl="http://$REPO_HOST/"
echo "$repoUrl"
### Solder setup
echo "Configuring solder"
# Change to use postgres for the database
sed -i.bak -E "s!('default' => )'\w+'!\1'pgsql'!g" app/config/database.php
sed -i.bak -E "s!('host'     => )'\w+'!\1'$POSTGRES_HOST'!" app/config/database.php
sed -i.bak -E "s!('database' => )'\w+'!\1'$POSTGRES_DB'!" app/config/database.php
sed -i.bak -E "s!('username' => )'\w+'!\1'$POSTGRES_USER'!" app/config/database.php
sed -i.bak -E "s!('password' => )''!\1'$POSTGRES_PASSWORD'!" app/config/database.php
# Setup file storage
sed -i.bak -E "s!('repo_location' => )'(.+)'!\1'/var/www/repo.solder/'!" app/config/solder.php
sed -i.bak -E "s!('mirror_url' => )'(.+)'!\1'$REPO_HOST'!" app/config/solder.php
# Setup the solder app
sed -i.bak -E "s!('url' => )'http://solder\.test'!\1'$repoUrl'!" app/config/app.php
# Hack for php7.1 not liking mcrypt
sed -i.bak -E "2s/\s?/error_reporting(E_ALL ^ E_DEPRECATED);/" app/config/app.php
# enable debug mode by default
sed -i.bak "s|'debug' => false|'debug' => true|g" app/config/app.php

echo "Running php artisan migrate:install"
# Setup the database data
php artisan migrate:install
echo "Running actual migration"
php artisan --force migrate

## Setup GFS
gfs -persist -username "$REPO_USER" -password "$REPO_PASSWORD" -serve /var/www/repo.solder

/usr/sbin/php-fpm7 -F
