# Symfony 8.1 Docker Starter

Docker starter for Symfony 8.1 with:

- PHP 8.4 FPM
- Nginx
- PostgreSQL 17
- Redis 8
- RabbitMQ 4 + Management UI
- Elasticsearch 9
- Mailpit
- Symfony Messenger worker
- Symfony Scheduler worker
- OPcache
- Xdebug
- dev/prod Compose overrides
- Makefile

## Create the Symfony project

```bash
symfony new my_project_directory --version="8.1.*"
cd my_project_directory
```

Copy this starter into the project root.

## Environment

```bash
cp .env.example .env
```

Change `APP_SECRET` and credentials for anything beyond local development.

## Start development

```bash
docker compose up -d --build
```

Because `compose.override.yaml` is automatically loaded, local ports are exposed.

## URLs

- Symfony: http://localhost:8080
- Mailpit: http://localhost:8025
- RabbitMQ Management: http://localhost:15672
- Elasticsearch: http://localhost:9200

Default RabbitMQ credentials:

```text
user: app
password: secret
```

## Install Symfony packages

Typical packages:

```bash
docker compose exec php composer require symfony/orm-pack
docker compose exec php composer require symfony/messenger
docker compose exec php composer require symfony/scheduler
docker compose exec php composer require symfony/mailer
docker compose exec php composer require elasticsearch/elasticsearch
```

For PostgreSQL migrations:

```bash
make db-create
make db-migrate
```

## Messenger

The `worker` service consumes:

```text
async
```

Configure your transport with:

```dotenv
MESSENGER_TRANSPORT_DSN="amqp://app:secret@rabbitmq:5672/%2f/messages"
```

Run worker logs:

```bash
make logs-worker
```

## Scheduler

The `scheduler` service consumes:

```text
scheduler_default
```

A task can be registered with Symfony Scheduler attributes, for example:

```php
#[AsCronTask('0 3 * * *')]
public function __invoke(): void
{
    // task
}
```

## Xdebug

Xdebug is installed in the `dev` image.

Configure your IDE to listen on port:

```text
9003
```

For PhpStorm the IDE key is:

```text
PHPSTORM
```

## Production

Do not use the development override.

Run:

```bash
docker compose -f compose.yaml -f compose.prod.yaml up -d --build
```

Before production, provide real secrets through the deployment environment/secret manager and configure TLS at the edge.

## Elasticsearch

The local setup disables Elasticsearch security:

```text
xpack.security.enabled=false
```

This is for development only. Do not expose an unsecured Elasticsearch instance publicly.

## Useful commands

```bash
make up
make down
make ps
make logs
make shell
make db-migrate
make cache-clear
make test
```

Examples:

```bash
make console CMD="about"
make composer CMD="require symfony/messenger"
```

## Linux + Elasticsearch

Elasticsearch may require:

```bash
sudo sysctl -w vm.max_map_count=1048576
```

For a persistent host setting, configure it in `/etc/sysctl.conf` according to your OS administration practices.
