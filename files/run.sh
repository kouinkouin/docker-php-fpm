#!/bin/bash
set -e

CONF_FILE=/etc/php/$PHP_VERSION/fpm/pool.d/www.conf

if [ ! -f $CONF_FILE ]; then
    echo "[error] $CONF_FILE does not exist, that's not a standard situation"
    exit 1
fi

usermod -u $UID -g $GID www-data

#GLOBAL_PARAMS="error_log=/proc/self/fd/2 access.log=/proc/self/fd/2 clear_env=no catch_workers_output=yes"

if [ -v GLOBAL_PARAMS ]; then
    echo "[info] GLOBAL_PARAMS=$GLOBAL_PARAMS"
    # GLOBAL_PARAMS="post_max_size=8M upload_max_filesize=2M"
    for param in $GLOBAL_PARAMS; do
	echo "[info]  param=$param"
	# param="post_max_size=8M"
	key=$(echo "$param" | cut -d'=' -f1)
	value=$(echo "$param" | cut -d'=' -f2-)
	echo "[info]   key=$key ; value=$value"
	sed -ir 's#^'\;$key\ =.*$'#'$key' = '$value'#' $CONF_FILE
	[ grep -n ^$key $CONF_FILE -eq 0 ] && echo "$key = $value" >> $CONF_FILE
	echo "[info]   "$(grep ^$key $CONF_FILE)
    done
else
    echo "[info] GLOBAL_PARAMS not defined"
fi

if [ -v PHP_ADMIN_VALUES ]; then
    echo "[info] PHP_ADMIN_VALUES=$PHP_ADMIN_VALUES"
    # PHP_ADMIN_VALUES="post_max_size=8M upload_max_filesize=2M"
    for param in $PHP_ADMIN_VALUES; do
	echo "[info]  param=$param"
	# param="post_max_size=8M"
	key=$(echo "$param" | cut -d'=' -f1)
	value=$(echo "$param" | cut -d'=' -f2-)
	echo "[info]   key=$key ; value=$value"
	line="php_admin_value[$key] = $value"
	echo "[info]   $line"
	echo $line >> $CONF_FILE
    done
else
    echo "[info] PHP_ADMIN_VALUES not defined"
fi

if [ -v PHP_ADMIN_FLAGS ]; then
    echo "[info] PHP_ADMIN_FLAGS=$PHP_ADMIN_FLAGS"
    # PHP_ADMIN_FLAGS="log_errors=on"
    for param in $PHP_ADMIN_FLAGS; do
	echo "[info]  param=$param"
	# param="log_errors=on"
	key=$(echo "$param" | cut -d'=' -f1)
	value=$(echo "$param" | cut -d'=' -f2-)
	echo "[info]   key=$key ; value=$value"
	line="php_admin_flag[$key] = $value"
	echo "[info]   $line"
	echo $line >> $CONF_FILE
    done
else
    echo "[info] PHP_ADMIN_FLAGS not defined"
fi

if [ -v PHP_FLAGS ]; then
    echo "[info] PHP_FLAGS=$PHP_FLAGS"
    # PHP_FLAGS="log_errors=on"
    for param in $PHP_FLAGS; do
	echo "[info]  param=$param"
	# param="log_errors=on"
	key=$(echo "$param" | cut -d'=' -f1)
	value=$(echo "$param" | cut -d'=' -f2-)
	echo "[info]   key=$key ; value=$value"
	line="php_flag[$key] = $value"
	echo "[info]   $line"
	echo $line >> $CONF_FILE
    done
else
    echo "[info] PHP_FLAGS not defined"
fi

exec $@

