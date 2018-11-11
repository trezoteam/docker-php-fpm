#!/bin/bash
if [ "$SLOW_LOG" == "true" ]; then
    SLOW_LOG_TIMEOUT=${SLOW_LOG_TIMEOUT:-10}
    for file in /etc/php/5.6/fpm/pool.d/* ; do
        echo "slowlog = /var/log/php-fpm/php5.6-slow.log" >> $file
        echo "request_slowlog_timeout = ${SLOW_LOG_TIMEOUT}" >> $file
    done
fi

if set | grep PROJECT_ROOT ; then
    cd $PROJECT_ROOT
    composer install &
fi

if php-fpm5.6 -t ; then
    exec php-fpm5.6 --nodaemonize --fpm-config /etc/php/5.6/fpm/php-fpm.conf
else
    echo "php-fpm5.6 config test failed, recheck it"
fi

