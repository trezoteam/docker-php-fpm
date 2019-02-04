FROM debian:stretch-slim

RUN apt-get update && apt-get install -y ca-certificates apt-transport-https wget gnupg git \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update

RUN apt-get install -y php7.1 php7.1-common php7.1-cli php7.1-fpm php7.1-opcache php7.1-xml php7.1-ctype php7.1-ftp php7.1-gd php7.1-json php7.1-posix php7.1-curl php7.1-dom php7.1-pdo php7.1-sockets php7.1-zip php7.1-mcrypt php7.1-mysql php7.1-mysqli php7.1-sqlite3 php7.1-bz2 php7.1-exif php7.1-phar php7.1-posix php7.1-calendar php7.1-iconv php7.1-imap php7.1-soap php7.1-xsl php7.1-ldap php7.1-bcmath php7.1-redis php7.1-memcache php7.1-memcached php7.1-imagick php7.1-intl php7.1-json php7.1-mcrypt php7.1-mysqli php7.1-readline php7.1-xmlrpc php7.1-xsl php7.1-mbstring php7.1-gmp php7.1-recode php7.1-dev php7.1-tidy php7.1-xdebug

RUN apt-get install -y php-symfony-class-loader php-pear php-tcpdf phpqrcode php-html-safe php-php-gettext php-gettext php-geoip php-oauth php-mail

RUN pecl install pecl/lzf \
    && echo "extension=lzf.so" > /etc/php/7.1/fpm/conf.d/lzf.ini \
    && echo "extension=lzf.so" > /etc/php/7.1/cli/conf.d/lzf.ini

RUN rm /etc/php/7.1/fpm/pool.d/* \
    && mkdir -p /var/run/php-fpm \
    && mkdir -p /var/log/php-fpm \
    && mkdir -p /run/php

RUN wget https://files.magerun.net/n98-magerun.phar && chmod +x n98-magerun.phar && mv n98-magerun.phar /bin/n98-magerun \
    && wget https://files.magerun.net/n98-magerun2.phar && chmod +x n98-magerun2.phar && mv n98-magerun2.phar /bin/n98-magerun2

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN mkdir -p /root/.ssh && echo "gitlab.com,52.167.219.168 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KW    jbjTDTdDkoohFzgbEY=" >> /root/.ssh/known_hosts

COPY config/pools/* /etc/php/7.1/fpm/pool.d/
COPY config/php.ini /etc/php/7.1/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh

RUN useradd deploy -s /bin/bash -g www-data -u 2500

RUN apt-get purge -y wget gnupg \
    && rm -Rf /var/cache/*

RUN groupadd http_group && useradd -m http_user -g http_group

CMD ["/entrypoint.sh"]

