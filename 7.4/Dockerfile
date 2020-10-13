FROM debian:buster-slim

RUN apt-get update && apt-get install -y wget curl ca-certificates apt-transport-https wget gnupg git \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update

RUN apt-get install -y php7.4 php7.4-common php7.4-cli php7.4-fpm php7.4-opcache php7.4-xml php7.4-ctype php7.4-ftp php7.4-gd php7.4-json php7.4-posix php7.4-curl php7.4-dom php7.4-pdo php7.4-sockets php7.4-zip php7.4-mysql php7.4-mysqli php7.4-sqlite3 php7.4-bz2 php7.4-exif php7.4-phar php7.4-posix php7.4-calendar php7.4-iconv php7.4-imap php7.4-soap php7.4-xsl php7.4-ldap php7.4-bcmath php7.4-redis php7.4-memcache php7.4-memcached php7.4-imagick php7.4-intl php7.4-json php7.4-mysqli php7.4-readline php7.4-xmlrpc php7.4-xsl php7.4-mbstring php7.4-gmp php7.4-recode php7.4-dev php7.4-tidy php7.4-xdebug

RUN apt-get install -y php-symfony-class-loader php-pear phpqrcode php-php-gettext php-gettext php-geoip php-oauth php-mail

RUN apt-get install -y php-dev libmcrypt-dev php-pear
RUN pecl channel-update pecl.php.net
RUN pecl install channel://pecl.php.net/mcrypt-1.0.2

RUN apt-get install -y gcc make autoconf libc-dev pkg-config php7.4-dev libmcrypt-dev \
    && echo "extension=mcrypt.so" > /etc/php/7.4/fpm/conf.d/lzf.ini \
    && echo "extension=mcrypt.so" > /etc/php/7.4/cli/conf.d/lzf.ini

RUN pecl install pecl/lzf \
    && echo "extension=lzf.so" > /etc/php/7.4/fpm/conf.d/lzf.ini \
    && echo "extension=lzf.so" > /etc/php/7.4/cli/conf.d/lzf.ini

RUN rm /etc/php/7.4/fpm/pool.d/* \
    && mkdir -p /var/run/php-fpm \
    && mkdir -p /var/log/php-fpm \
    && mkdir -p /run/php

RUN wget https://files.magerun.net/n98-magerun.phar && chmod +x n98-magerun.phar && mv n98-magerun.phar /bin/n98-magerun \
    && wget https://files.magerun.net/n98-magerun2.phar && chmod +x n98-magerun2.phar && mv n98-magerun2.phar /bin/n98-magerun2

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN mkdir -p /root/.ssh && echo "gitlab.com,52.167.419.168 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KW    jbjTDTdDkoohFzgbEY=" >> /root/.ssh/known_hosts

COPY config/pools/* /etc/php/7.4/fpm/pool.d/
COPY config/php.ini /etc/php/7.4/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh

# ioncube loader module
RUN cd /tmp \
	&& curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.4.so /usr/lib/php/20180731/ \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_7.4.so" >> /etc/php/7.4/fpm/php.ini \
    && echo "zend_extension=ioncube_loader_lin_7.4.so" >> ./etc/php/7.4/cli/php.ini \
    && service php7.4-fpm restart

RUN useradd deploy -s /bin/bash -g www-data -u 2500

RUN apt-get purge -y wget gnupg \
    && rm -Rf /var/cache/*

RUN groupadd http_group && useradd -s /bin/bash -m http_user -g http_group

RUN echo 'su http_user' >> /root/.bashrc

CMD ["/entrypoint.sh"]

