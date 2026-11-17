FROM php:8.4-fpm-bookworm AS base

ENV APP_ENV=prod
WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git unzip curl libicu-dev libpq-dev libzip-dev \
        librabbitmq-dev libonig-dev libxml2-dev libssl-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j"$(nproc)" intl opcache pdo_pgsql zip \
    && pecl install redis amqp \
    && docker-php-ext-enable redis amqp \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY docker/php/conf.d/app.ini /usr/local/etc/php/conf.d/app.ini
COPY docker/php/conf.d/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

FROM base AS dev
ENV APP_ENV=dev

RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY docker/php/entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

FROM base AS vendor
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-interaction --prefer-dist --optimize-autoloader

FROM base AS prod
ENV APP_ENV=prod

COPY --from=vendor /var/www/html/vendor ./vendor
COPY . .

RUN composer dump-autoload --classmap-authoritative --no-dev --no-interaction \
    && mkdir -p var/cache var/log \
    && chown -R www-data:www-data var

USER www-data
CMD ["php-fpm"]
