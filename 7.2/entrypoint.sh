#!/bin/bash
set -x
if [ "$SLOW_LOG" == "true" ]; then
    SLOW_LOG_TIMEOUT=${SLOW_LOG_TIMEOUT:-10}
    for file in /etc/php/7.2/fpm/pool.d/* ; do
        echo "slowlog = /var/log/php-fpm/php7.2-slow.log" >> $file
        echo "request_slowlog_timeout = ${SLOW_LOG_TIMEOUT}" >> $file
    done
fi

if set | grep XDEBUG_REMOTE_HOST ; then
    echo "
zend_extension=xdebug.so
[Xdebug]
xdebug.remote_host=${XDEBUG_REMOTE_HOST}
xdebug.remote_enable=true
xdebug.remote_port=9000
xdebug.max_nesting_level=5000
xdebug.remote_autostart = 1
xdebug.remote_log=/var/log/php-fpm/xdebug.log
" > /etc/php/7.2/fpm/conf.d/20-xdebug.ini
fi

if set | grep PROJECT_ROOT ; then
    file=$(find $PROJECT_ROOT -maxdepth 1 -type f | head -n1)
    outsider_uid=$(ls -l $file | cut -f 3 -d ' ')
    outsider_gid=$(ls -l $file | cut -f 4 -d ' ')

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
if php-fpm7.2 -t ; then
    exec php-fpm7.2 --nodaemonize --fpm-config /etc/php/7.2/fpm/php-fpm.conf
else
    echo "php-fpm7.2 config test failed, recheck it"
fi

