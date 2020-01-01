FROM alpine:latest

# Download and instsall dependencies
RUN apk --no-cache add nginx ca-certificates wget curl \
        php7-cli php7-curl php7-mcrypt php7-apcu php7-fpm \
        php7-sqlite3 php7-json php7-phar php7-iconv php7 \
        php7-mbstring php7-xml php7-fileinfo php7-openssl \
        php7-dom php7-tokenizer php7-ctype php7-pdo php7-pgsql \ 
        php7-pdo_pgsql php7-gd
# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'baf1608c33254d00611ac1705c1d9958c817a1a33bce370c0595974b342601bd80b92a3f46067da89e3b06bff421f182') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"
# Add gosu for easier sudo management
RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu
# Download and extract solder
RUN wget http://github.com/TechnicPack/TechnicSolder/archive/master.tar.gz -O - | tar -xzf - -C /var/www
# Better file naming
RUN mv var/www/TechnicSolder-master var/www/technicsolder
# Install solder dependencies (We have to run it twice, as it sometimes fails just because)
RUN cd /var/www/technicsolder && \
    php /composer.phar install --no-dev --no-interaction && \
    php /composer.phar install --no-dev --no-interaction && \
    chown -R nginx . && \
    chmod -R 777 ./app/storage && \
    chmod -R 777 /var/www/technicsolder/public && \
    cd /

# Add gpm for easier file upload
RUN curl -o /usr/local/bin/gpm -sSL "https://github.com/zlepper/gpm/releases/download/1.0.1/gpm-1.0.1-linux-x64" && \
    chmod +x /usr/local/bin/gpm 

# Add gfs for easier file upload
RUN curl -o /usr/local/bin/gfs -sSL "https://github.com/zlepper/gfs/releases/download/0.0.4/gfs-linux-x64" && \
    chmod +x /usr/local/bin/gfs 

# Allow using an external storage for postgres
ENV PGDATA=/var/lib/postgresql/data \
    LANG=en_US.utf8\
    # Host used when connection to solder
    SOLDER_HOST=solder.app \
    # Host used when connection to repo
    REPO_HOST=repo.app\
    REPO_USER=solder\
    REPO_PASSWORD=solder

# Storage location for postgres data
VOLUME /var/lib/postgresql/data \
    # Storage location for mod files
    /var/www/repo.solder \
    # Storage location for various special solder files
    /var/www/technicsolder/app/storage \
    # Storage location for another bunch of special solder files
    /var/www/technicsolder/public/storage


# Copy setup scripts
COPY ./add /

RUN chmod +x /var/scripts/setup.sh && \
    chmod +x /var/scripts/setup-postgres.sh

# Actually configure solder
ENTRYPOINT ["/usr/local/bin/gpm"]
CMD ["-config", "/var/gpm-config.json"]
