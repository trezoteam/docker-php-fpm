#!/bin/bash
set -x
if [ "$SLOW_LOG" == "true" ]; then
    SLOW_LOG_TIMEOUT=${SLOW_LOG_TIMEOUT:-10}
    for file in /etc/php/7.1/fpm/pool.d/* ; do
        echo "slowlog = /var/log/php-fpm/php7.1-slow.log" >> $file
        echo "request_slowlog_timeout = ${SLOW_LOG_TIMEOUT}" >> $file
    done
fi


if set | grep PROJECT_ROOT ; then
    outsider_uid=$(ls -l $PROJECT_ROOT/composer.json | cut -f 3 -d ' ')
    outsider_gid=$(ls -l $PROJECT_ROOT/composer.json | cut -f 4 -d ' ')

    if [[ $outsider_uid =~ ^[0-9]*$ ]]; then
        usermod http_user -u $outsider_uid
    fi

    if [[ $outsider_gid =~ ^[0-9]*$ ]]; then
        usermod http_group -g $outsider_gid
    fi

    cd $PROJECT_ROOT
    su http_user -c 'composer install' &
fi
set +x
if php-fpm7.1 -t ; then
    exec php-fpm7.1 --nodaemonize --fpm-config /etc/php/7.1/fpm/php-fpm.conf
else
    echo "php-fpm7.1 config test failed, recheck it"
fi

