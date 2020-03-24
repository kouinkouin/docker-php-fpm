FROM kouinkouin/debian-base:10

ARG PHP_VERSION=7.4

RUN wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list && \
    apt-get update

ENV PHP_VERSION=$PHP_VERSION UID=33 GID=33 PHP_FPM_STATUS_ENABLE=0 PHP_FPM_STATUS_PATH=/status

RUN \
    apt-get install -y \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-bz2 \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-memcached \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-readline \
        php${PHP_VERSION}-soap \
        php-ssh2 \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-xmlrpc \
        php${PHP_VERSION}-zip \
        php-sodium \
        gettext \
        && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

RUN mkdir /run/php && \
    ln -s php-fpm${PHP_VERSION} /usr/sbin/php-fpm && \
    ln -s ${PHP_VERSION}/fpm /etc/php/fpm && \
    echo

ARG is_for_production=1

RUN \
    if [ $is_for_production -ne 1 ]; then \
        apt-get update && \
        apt-get install -y php-xdebug && \
        apt-get clean && \
        rm -r /var/lib/apt/lists/* ;\
    fi

ADD files/composer-setup.php /tmp/composer-setup.php

RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer && rm /tmp/composer-setup.php

ADD files/run.sh /usr/local/bin/run
ADD files/php-fpm.d /etc/php/fpm

RUN chmod +x /usr/local/bin/run

EXPOSE 9000

ENTRYPOINT ["run"]

CMD ["php-fpm", "-F"]

