FROM kouinkouin/debian-base

RUN wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list && \
    apt update 

ARG php_version=7.1

RUN \
    apt install -y \
        php${php_version} \
        php${php_version}-bcmath \
        php${php_version}-bz2 \
        php${php_version}-curl \
        php${php_version}-fpm \
        php${php_version}-gd \
        php${php_version}-intl \
        php${php_version}-json \
        php${php_version}-mcrypt \
        php${php_version}-mbstring \
        php${php_version}-mysql \
        php${php_version}-opcache \
        php${php_version}-readline \
        php${php_version}-soap \
        php${php_version}-xml \
        php${php_version}-xmlrpc \
        php${php_version}-zip \
        git \
        && \
    apt clean && \
    rm -r /var/lib/apt/lists/*

ADD files/composer-setup.php /tmp/composer-setup.php

RUN usermod -u 1000 www-data && \
    mkdir /run/php && \
    sed -i -r 's/^listen\ =.*$/listen = 9000/' /etc/php/${php_version}/fpm/pool.d/www.conf && \
    ln -s php-fpm${php_version} /usr/sbin/php-fpm

RUN php /tmp/composer-setup.php --filename=/usr/bin/composer && rm /tmp/composer-setup.php

CMD ["php-fpm", "-F"]

EXPOSE 9000

