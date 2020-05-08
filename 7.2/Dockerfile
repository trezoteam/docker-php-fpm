FROM debian:stretch-slim

RUN apt-get update && apt-get install -y ca-certificates apt-transport-https wget gnupg git \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update

RUN apt-get install -y php7.2 php7.2-common php7.2-cli php7.2-fpm php7.2-opcache php7.2-xml php7.2-ctype php7.2-ftp php7.2-gd php7.2-json php7.2-posix php7.2-curl php7.2-dom php7.2-pdo php7.2-sockets php7.2-zip php7.2-mysql php7.2-mysqli php7.2-sqlite3 php7.2-bz2 php7.2-exif php7.2-phar php7.2-posix php7.2-calendar php7.2-iconv php7.2-imap php7.2-soap php7.2-xsl php7.2-ldap php7.2-bcmath php7.2-redis php7.2-memcache php7.2-memcached php7.2-imagick php7.2-intl php7.2-json php7.2-mysqli php7.2-readline php7.2-xmlrpc php7.2-xsl php7.2-mbstring php7.2-gmp php7.2-recode php7.2-dev php7.2-tidy php7.2-xdebug

RUN apt-get install -y php-symfony-class-loader php-pear php-tcpdf phpqrcode php-html-safe php-php-gettext php-gettext php-geoip php-oauth php-mail

RUN apt-get install -y gcc make autoconf libc-dev pkg-config php7.2-dev libmcrypt-dev \
    && pecl install mcrypt-1.0.1 \
    && echo "extension=mcrypt.so" > /etc/php/7.2/fpm/conf.d/lzf.ini \
    && echo "extension=mcrypt.so" > /etc/php/7.2/cli/conf.d/lzf.ini

RUN pecl install pecl/lzf \
    && echo "extension=lzf.so" > /etc/php/7.2/fpm/conf.d/lzf.ini \
    && echo "extension=lzf.so" > /etc/php/7.2/cli/conf.d/lzf.ini

RUN rm /etc/php/7.2/fpm/pool.d/* \
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

COPY config/pools/* /etc/php/7.2/fpm/pool.d/
COPY config/php.ini /etc/php/7.2/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh

# ioncube loader module
RUN cd /tmp \
	&& curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.2.so /usr/lib/php/20170718/ \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=/usr/lib/php/20170718/ioncube_loader_lin_7.2.so" >> /etc/php/7.2/fpm/php.ini \
    && echo "zend_extension=/usr/lib/php/20170718/ioncube_loader_lin_7.2.so" >> ./etc/php/7.2/cli/php.ini
    
RUN useradd deploy -s /bin/bash -g www-data -u 2500

RUN apt-get purge -y wget gnupg \
    && rm -Rf /var/cache/*

RUN groupadd http_group && useradd -s /bin/bash -m http_user -g http_group

RUN echo 'su http_user' >> /root/.bashrc

CMD ["/entrypoint.sh"]

