FROM php:7.2-fpm

RUN \
    apt update

RUN apt install -y \
        # used for php ext bz2
        libbz2-dev \
        # used for php ext gd
        libpng-dev libjpeg-dev \
        # used for php ext intl
        libicu-dev \
        # used for php ext readline
        #libedit-dev \
        # used for php ext xml
        libxml2-dev \
    && \
    apt clean && \
    rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install --help

RUN \
    docker-php-ext-install \
        xml \
        bcmath \
        bz2 \
        gd \
        intl \
        mysqli \
        opcache \
        soap \
        xmlrpc \
        zip \
        -j$(nproc)

ADD files/composer-setup.php /tmp/composer-setup.php

RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer && rm /tmp/composer-setup.php

