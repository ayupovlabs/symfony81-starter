SHELL := /bin/sh

.PHONY: up down restart build logs shell composer console \
        db-migrate db-rollback db-create db-drop cache-clear \
        test phpstan cs-fix cs-check ps

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

build:
	docker compose build --no-cache

ps:
	docker compose ps

logs:
	docker compose logs -f

logs-php:
	docker compose logs -f php

logs-worker:
	docker compose logs -f worker

logs-scheduler:
	docker compose logs -f scheduler

shell:
	docker compose exec php bash

composer:
	docker compose exec php composer $(CMD)

console:
	docker compose exec php php bin/console $(CMD)

db-migrate:
	docker compose exec php php bin/console doctrine:migrations:migrate --no-interaction

db-rollback:
	docker compose exec php php bin/console doctrine:migrations:migrate prev --no-interaction

db-create:
	docker compose exec php php bin/console doctrine:database:create --if-not-exists

db-drop:
	docker compose exec php php bin/console doctrine:database:drop --force --if-exists

cache-clear:
	docker compose exec php php bin/console cache:clear

test:
	docker compose exec php php bin/phpunit

phpstan:
	docker compose exec php vendor/bin/phpstan analyse

cs-fix:
	docker compose exec php vendor/bin/php-cs-fixer fix

cs-check:
	docker compose exec php vendor/bin/php-cs-fixer check
