#!/bin/sh
set -e

cd /var/www/html

if [ ! -d vendor ] || [ -z "$(ls -A vendor 2>/dev/null)" ]; then
    echo "Installing Composer dependencies..."
    composer install --no-interaction --prefer-dist
fi

exec "$@"
