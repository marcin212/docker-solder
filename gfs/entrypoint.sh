#!/bin/sh

## Setup GFS
gfs -persist -username "$REPO_USER" -password "$REPO_PASSWORD" -serve /var/www/repo.solder

# Rum GFS
gfs
