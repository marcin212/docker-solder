sed -i.bak "s|;error_log\s*=\s*log/php7/error.log|error_log = /proc/self/fd/2|g" /etc/php7/php-fpm.conf
sed -i.bak "s|user\s*=\s*nobody|user = www-data|g" /etc/php7/php-fpm.d/www.conf
sed -i.bak "s|group\s*=\s*nobody|group = www-data|g" /etc/php7/php-fpm.d/www.conf
sed -i.bak "s|;*listen\s*=\s*127.0.0.1:9000|listen = 0.0.0.0:9000|g" /etc/php7/php-fpm.d/www.conf
sed -i.bak "s|;*listen.owner\s*=\s*nobody|listen.owner = www-data|g" /etc/php7/php-fpm.d/www.conf
sed -i.bak "s|;*listen.group\s*=\s*nobody|listen.group = www-data|g" /etc/php7/php-fpm.d/www.conf
