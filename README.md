# docker-php-fpm

# Usage
* Sockets are created in /var/run/php-fpm/
* You can enable slow log by setting the environment variable SLOW_LOG to "true"
* The default timeout value for slowlog is 10s, but this can be overwritten with SLOW_LOG_TIMEOUT
* Want me to run 'composer install' for you? Set the variable PROJECT_ROOT so I know where to run it
