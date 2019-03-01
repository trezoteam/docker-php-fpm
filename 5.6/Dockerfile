FROM debian:stretch-slim

RUN apt-get update && apt-get install -y ca-certificates apt-transport-https wget gnupg git \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y php5.6 php5.6 php5.6-common php5.6-cli php5.6-fpm php5.6-opcache php5.6-xml php5.6-ctype php5.6-ftp php5.6-gd php5.6-json php5.6-posix php5.6-curl php5.6-dom php5.6-pdo php5.6-sockets php5.6-zip php5.6-mcrypt php5.6-mysql php5.6-mysqli php5.6-sqlite3 php5.6-bz2 php5.6-exif php5.6-phar php5.6-posix php5.6-calendar php5.6-iconv php5.6-imap php5.6-soap php5.6-xsl php5.6-ldap php5.6-bcmath php5.6-redis php5.6-memcache php5.6-memcached php5.6-imagick php5.6-intl php5.6-json php5.6-mcrypt php5.6-mysqli php5.6-readline php5.6-xmlrpc php5.6-xsl php5.6-mbstring php5.6-gmp php5.6-recode php5.6-dev php5.6-tidy php5.6-xdebug

RUN apt-get install -y php-symfony-class-loader php-pear php-tcpdf phpqrcode php-html-safe php-php-gettext php-gettext php-geoip php-oauth php-mail

RUN pecl install pecl/lzf \
    && echo "extension=lzf.so" > /etc/php/5.6/fpm/conf.d/lzf.ini \
    && echo "extension=lzf.so" > /etc/php/5.6/cli/conf.d/lzf.ini

RUN rm /etc/php/5.6/fpm/pool.d/* \
    && mkdir -p /var/run/php-fpm \
    && mkdir -p /var/log/php-fpm \
    && mkdir -p /run/php

RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvf ioncube_loaders_lin_x86-64.tar.gz \
    && cp ioncube/ioncube_loader_lin_5.6.so $(php -i | grep ^extension_dir | cut -d' ' -f3) \
    && echo "zend_extension = $(php -i | grep ^extension_dir | cut -d' ' -f3)/ioncube_loader_lin_5.6.so" > /etc/php/5.6/fpm/conf.d/00-ioncube.ini \
    && echo "zend_extension = $(php -i | grep ^extension_dir | cut -d' ' -f3)/ioncube_loader_lin_5.6.so" > /etc/php/5.6/cli/conf.d/00-ioncube.ini \
&& rm -Rf /ioncube*

RUN wget https://files.magerun.net/n98-magerun.phar && chmod +x n98-magerun.phar && mv n98-magerun.phar /bin/n98-magerun \
    && wget https://files.magerun.net/n98-magerun2.phar && chmod +x n98-magerun2.phar && mv n98-magerun2.phar /bin/n98-magerun2

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN mkdir -p /root/.ssh && echo "gitlab.com,52.167.219.168 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KW    jbjTDTdDkoohFzgbEY=" >> /root/.ssh/known_hosts

COPY config/pools/* /etc/php/5.6/fpm/pool.d/
COPY config/php.ini /etc/php/5.6/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh

RUN apt-get purge -y wget gnupg \
    && rm -Rf /var/cache/*

RUN groupadd http_group && useradd -s /bin/bash -m http_user -g http_group

RUN echo 'su http_user' >> /root/.bashrc

CMD ["/entrypoint.sh"]

