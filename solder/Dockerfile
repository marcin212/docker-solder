FROM alpine:latest

WORKDIR /var/www/

# Download and install dependencies
RUN apk --no-cache add wget
# Download and install Solder dependencies
RUN apk --no-cache add composer php7-cli php7-curl php7-mcrypt php7-apcu php7-fpm php7-sqlite3 php7-xml php7-fileinfo \
                       php7-dom php7-tokenizer php7-ctype php7-pdo php7-pgsql php7-pdo_pgsql php7-gd

# Download and extract solder
RUN wget http://github.com/TechnicPack/TechnicSolder/archive/master.tar.gz -O - | tar -xzf -
# Better file naming
RUN mv ./TechnicSolder-master ./technicsolder

# Create default configs.
RUN mv ./technicsolder/app/config-sample ./technicsolder/app/config

# Changed working directory so composer can work without trouble
WORKDIR /var/www/technicsolder/

# Install solder dependencies.
RUN composer install --no-dev --no-interaction  --prefer-dist --no-ansi --no-scripts --optimize-autoloader
RUN composer clearcache

# Copy scripts
COPY ./entrypoint.sh .
COPY ./php_config.sh .

# Configure php-fpm
RUN sh ./php_config.sh

# create the app user
RUN addgroup -S www-data && adduser -S www-data -G www-data

# Change permisions.
RUN chown -R www-data:www-data .

# change to the app user
USER www-data

# Actually configure solder
ENTRYPOINT ["/var/www/technicsolder/entrypoint.sh"]
