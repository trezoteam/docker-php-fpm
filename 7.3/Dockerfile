FROM debian:stretch-slim

RUN apt-get update && apt-get install -y wget curl ca-certificates apt-transport-https wget gnupg git \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update

RUN apt-get install -y php7.3 php7.3-common php7.3-cli php7.3-fpm php7.3-opcache php7.3-xml php7.3-ctype php7.3-ftp php7.3-gd php7.3-json php7.3-posix php7.3-curl php7.3-dom php7.3-pdo php7.3-sockets php7.3-zip php7.3-mysql php7.3-mysqli php7.3-sqlite3 php7.3-bz2 php7.3-exif php7.3-phar php7.3-posix php7.3-calendar php7.3-iconv php7.3-imap php7.3-soap php7.3-xsl php7.3-ldap php7.3-bcmath php7.3-redis php7.3-memcache php7.3-memcached php7.3-imagick php7.3-intl php7.3-json php7.3-mysqli php7.3-readline php7.3-xmlrpc php7.3-xsl php7.3-mbstring php7.3-gmp php7.3-recode php7.3-dev php7.3-tidy php7.3-xdebug

RUN apt-get install -y php-symfony-class-loader php-pear php-tcpdf phpqrcode php-html-safe php-php-gettext php-gettext php-geoip php-oauth php-mail

RUN apt-get install -y gcc make autoconf libc-dev pkg-config php7.3-dev libmcrypt-dev \
    && pecl install mcrypt-1.0.1 \
    && echo "extension=mcrypt.so" > /etc/php/7.3/fpm/conf.d/lzf.ini \
    && echo "extension=mcrypt.so" > /etc/php/7.3/cli/conf.d/lzf.ini

RUN pecl install pecl/lzf \
    && echo "extension=lzf.so" > /etc/php/7.3/fpm/conf.d/lzf.ini \
    && echo "extension=lzf.so" > /etc/php/7.3/cli/conf.d/lzf.ini

RUN rm /etc/php/7.3/fpm/pool.d/* \
    && mkdir -p /var/run/php-fpm \
    && mkdir -p /var/log/php-fpm \
    && mkdir -p /run/php

RUN wget https://files.magerun.net/n98-magerun.phar && chmod +x n98-magerun.phar && mv n98-magerun.phar /bin/n98-magerun \
    && wget https://files.magerun.net/n98-magerun2.phar && chmod +x n98-magerun2.phar && mv n98-magerun2.phar /bin/n98-magerun2

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

RUN mkdir -p /root/.ssh && echo "gitlab.com,52.167.319.168 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KW    jbjTDTdDkoohFzgbEY=" >> /root/.ssh/known_hosts

COPY config/pools/* /etc/php/7.3/fpm/pool.d/
COPY config/php.ini /etc/php/7.3/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh

# ioncube loader module
RUN cd /tmp \
	&& curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20180731/ \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_7.3.so" >> /etc/php/7.3/fpm/php.ini \
    && echo "zend_extension=ioncube_loader_lin_7.3.so" >> ./etc/php/7.3/cli/php.ini \
    && service php7.3-fpm restart

RUN useradd deploy -s /bin/bash -g www-data -u 2500

RUN apt-get purge -y wget gnupg \
    && rm -Rf /var/cache/*

RUN groupadd http_group && useradd -s /bin/bash -m http_user -g http_group

RUN echo 'su http_user' >> /root/.bashrc

CMD ["/entrypoint.sh"]

