# Requriements
> Docker-capable Server
> Ports 80 and 8080 to be opened; 443 and 8443 for HTTPS
> 5 minutes of your time

# Upcoming Features // Changes
> TLSv1.3 support in NGINX; will require manual installation of OpenSSL v1.1.1
> Add documentation on installation of Docker
> More Love.

# What is Technic Solder?
> Technic Solder is a server-side PHP application based on the Laravel Framework. Its main goal is to provide delta encoded files for the Technic Launcher to process. This can include any type of file. Another goal is to process file check-sums to ensure the receiver is obtaining unaltered files.

More information can be found at: <http://docs.solder.io/>

# What is the purpose of this docker container?
First and foremost it's to be simple to configure. It should not require a PHD to be able to setup solder, yet there are quite a few gotchas to be aware of. There are quite a few solder containers in existence, but I have found that they either lack documentation, or have some other weird way of being setup that does not follow the official recommendations.

# Quickstart
This command starts your solder container for you. You only need to change the environment variables. 

```shell script
docker run -d --name=solder \
    -p 80:80 \
    -v /data/docker/solder/repo:/var/www/repo.solder \
    -v /data/docker/solder/storage:/var/www/technicsolder/app/storage \
    -v /data/docker/solder/public:/var/www/technicsolder/public \
    -e "SOLDER_HOST=solder.example.com" \
    -e "REPO_HOST=repo.example.com" \
    leonime/solder
```

# Configuration
This container makes only the most minimal options available to ensure easier setup.

## Environment variables
The main variables to be conserned about are the following:

|Variable name|Default value|Description|
|------|-------|------|
|`SOLDER_HOST`|solder.app|The hostname that solder app should have|
|`REPO_HOST`|repo.app|The hostname the file repo should have|
|`REPO_USER`|solder|The username used when uploading to the file repository|
|`REPO_PASSWORD`|solder|The password used when uploading to the file repository|
|`POSTGRES_PASSWORD`|postgres|The password for the database. If you are not opening the database to the world, then you don't actually need to change this.|

## Volumes
All of these volumes should be added to the host, this will ensure a smooth update when a new version of this container is out. 

|Volume path|Description|
|------|------|
|`/var/lib/postgresql/data`|All the database data|
|`/var/www/repo.solder`|Storage location for uploaded mod files|
|`/var/www/technicsolder/app/storage`|Various specific solder files|
|`/var/www/technicsolder/public/storage`|Various specific solder files|

## Ports
|Port number|Description|Recommendation|
|-------|-------|------|
|80|Solder http port. This is where you connection to solder. <br /> This should be linked if you want to be able to actually access solder(Which you want)|Link|
|443|Solder https port. Optional; SSL encrypted connection to your solder server.|Link|
|5432|PostgreSQL port. Do NOT open this to the world unless you intend to remotely access the database.|Don't link|
|8080|GFS http port. You need to open this to be able to upload files|Link|
|8443|GFS https port. Optional; you must enable this if you have linked port 443.|Link|

# Stack
This container is made of the following components:  
[Alpine Linux](https://alpinelinux.org/) as a base image  
[Nginx](https://nginx.org) as webserver  
[PostgreSQL](https://www.postgresql.org/) as database  
[GFS](https://github.com/zlepper/gfs) as file server (This is a replacement for FTP, and works entirely through your browser.) 



