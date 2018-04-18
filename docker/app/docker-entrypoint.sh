#!/bin/sh
set -eox pipefail

# Set the timezone. Base image does not contain the setup-timezone script, so an alternate way is used.
if [ "$CONTAINER_TIMEZONE" ]; then
    cp /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime && \
	echo "${CONTAINER_TIMEZONE}" >  /etc/timezone && \
	echo "Container timezone set to: $CONTAINER_TIMEZONE"
fi

# Force immediate synchronisation of the time and start the time-synchronization service.
# In order to be able to use ntpd in the container, it must be run with the SYS_TIME capability.
# In addition you may want to add the SYS_NICE capability, in order for ntpd to be able to modify its priority.
ntpd -d -n -p pool.ntp.org

# set permissions
usermod --non-unique --uid ${APP_UID:-101} www-data
groupmod --non-unique -g ${APP_GID:-102} www-data

cd /var/www/html/
composer install

if ! [ -e ".env" ]; then
	cp .env.example .env

	# db config
	sed -i "/^DB_.*/d" .env
	env | grep DB_ >> .env
	echo "" >> .env

	# mail config
	sed -i "/^MAIL.*/d" .env
	env | grep MAIL_ >> .env
	echo "" >> .env

	php artisan key:generate

fi


# wait for db
/wait

php artisan migrate

/usr/bin/supervisord -n -c /etc/supervisord.conf