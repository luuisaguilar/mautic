FROM mautic/mautic:latest

# Aumentar el límite de memoria de PHP
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1

RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs
