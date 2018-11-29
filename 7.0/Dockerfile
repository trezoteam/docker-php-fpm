FROM debian:stretch-slim

RUN apt-get update && apt-get install -y ca-certificates apt-transport-https wget gnupg git \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update

RUN apt-get install -y php7.0 php7.0-common php7.0-cli php7.0-fpm php7.0-opcache php7.0-xml php7.0-ctype php7.0-ftp php7.0-gd php7.0-json php7.0-posix php7.0-curl php7.0-dom php7.0-pdo php7.0-sockets php7.0-zip php7.0-mcrypt php7.0-mysql php7.0-mysqli php7.0-sqlite3 php7.0-bz2 php7.0-exif php7.0-phar php7.0-posix php7.0-calendar php7.0-iconv php7.0-imap php7.0-soap php7.0-xsl php7.0-ldap php7.0-bcmath php7.0-redis php7.0-memcache php7.0-memcached php7.0-imagick php7.0-intl php7.0-json php7.0-mcrypt php7.0-mysqli php7.0-readline php7.0-xmlrpc php7.0-xsl php7.0-mbstring php7.0-gmp php7.0-recode php7.0-dev php7.0-tidy php7.0-xdebug

RUN apt-get install -y php-symfony-class-loader php-pear php-tcpdf phpqrcode php-html-safe php-php-gettext php-gettext php-geoip php-oauth php-mail

RUN pecl install pecl/lzf \
    && echo "extension=lzf.so" > /etc/php/7.0/fpm/conf.d/lzf.ini \
    && echo "extension=lzf.so" > /etc/php/7.0/cli/conf.d/lzf.ini

RUN rm /etc/php/7.0/fpm/pool.d/* \
    && mkdir -p /var/run/php-fpm \
    && mkdir -p /var/log/php-fpm \
    && mkdir -p /run/php

RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvf ioncube_loaders_lin_x86-64.tar.gz \
    && cp ioncube/ioncube_loader_lin_7.0.so $(php -i | grep ^extension_dir | cut -d' ' -f3) \
    && echo "zend_extension = $(php -i | grep ^extension_dir | cut -d' ' -f3)/ioncube_loader_lin_7.0.so" > /etc/php/7.0/fpm/conf.d/00-ioncube.ini \
    && echo "zend_extension = $(php -i | grep ^extension_dir | cut -d' ' -f3)/ioncube_loader_lin_7.0.so" > /etc/php/7.0/cli/conf.d/00-ioncube.ini \
    && rm -Rf /ioncube*

RUN wget https://files.magerun.net/n98-magerun.phar && chmod +x n98-magerun.phar && mv n98-magerun.phar /bin/n98-magerun \
    && wget https://files.magerun.net/n98-magerun2.phar && chmod +x n98-magerun2.phar && mv n98-magerun2.phar /bin/n98-magerun2

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN mkdir -p /root/.ssh && echo "gitlab.com,52.167.219.168 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KW    jbjTDTdDkoohFzgbEY=" >> /root/.ssh/known_hosts

COPY config/pools/* /etc/php/7.0/fpm/pool.d/
COPY config/php.ini /etc/php/7.0/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh

RUN useradd deploy -s /bin/bash -g www-data -u 2500

RUN apt-get purge -y wget gnupg \
    && rm -Rf /var/cache/*

CMD ["/entrypoint.sh"]

