#!/bin/bash
if [ "$SLOW_LOG" == "true" ]; then
    SLOW_LOG_TIMEOUT=${SLOW_LOG_TIMEOUT:-10}
    for file in /etc/php/7.1/fpm/pool.d/* ; do
        echo "slowlog = /var/log/php-fpm/php7.1-slow.log" >> $file
        echo "request_slowlog_timeout = ${SLOW_LOG_TIMEOUT}" >> $file
    done
fi

if set | grep PROJECT_ROOT ; then
    cd $PROJECT_ROOT
    composer install &
fi

if php-fpm7.1 -t ; then
    exec php-fpm7.1 --nodaemonize --fpm-config /etc/php/7.1/fpm/php-fpm.conf
else
    echo "php-fpm7.1 config test failed, recheck it"
fi

