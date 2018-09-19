FROM debian:stretch-slim

RUN apt-get update && apt-get install -y ca-certificates apt-transport-https wget gnupg git \
    && wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update

RUN apt-get install -y php7.0 php7.0-common php7.0-cli php7.0-fpm php7.0-opcache php7.0-xml php7.0-ctype php7.0-ftp php7.0-gd php7.0-json php7.0-posix php7.0-curl php7.0-dom php7.0-pdo php7.0-sockets php7.0-zip php7.0-mcrypt php7.0-mysql php7.0-mysqli php7.0-sqlite3 php7.0-bz2 php7.0-exif php7.0-phar php7.0-posix php7.0-calendar php7.0-iconv php7.0-imap php7.0-soap php7.0-xsl php7.0-ldap php7.0-bcmath php7.0-redis php7.0-memcache php7.0-memcached php7.0-imagick php7.0-intl php7.0-json php7.0-mcrypt php7.0-mysqli php7.0-readline php7.0-xmlrpc php7.0-xsl php7.0-mbstring php7.0-gmp php7.0-recode php7.0-dev php7.0-tidy 

RUN apt-get install -y php-symfony-class-loader php-pear php-tcpdf phpqrcode php-html-safe php-php-gettext php-gettext php-geoip php-oauth php-mail

RUN pecl install pecl/lzf \
    && echo "extension=lzf.so" > /etc/php/7.0/fpm/conf.d/lzf.ini

RUN rm /etc/php/7.0/fpm/pool.d/* \
    && mkdir -p /var/run/php-fpm \
    && mkdir -p /var/log/php-fpm \
    && mkdir -p /run/php

RUN wget https://files.magerun.net/n98-magerun.phar && chmod +x n98-magerun.phar && mv n98-magerun.phar /bin/n98-magerun \
    && wget https://files.magerun.net/n98-magerun2.phar && chmod +x n98-magerun2.phar && mv n98-magerun2.phar /bin/n98-magerun2

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

COPY config/pools/* /etc/php/7.0/fpm/pool.d/
COPY config/php.ini /etc/php/7.0/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh

RUN apt-get purge -y wget gnupg \
    && rm -Rf /var/cache/*

CMD ["/entrypoint.sh"]
