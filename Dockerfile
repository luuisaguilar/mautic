# Usa una imagen de PHP con soporte para Composer y Node.js
FROM php:8.1-apache

# Instala dependencias necesarias para Composer y npm
RUN apt-get update && apt-get install -y curl unzip git nodejs npm \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar variables de entorno para evitar problemas de memoria
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias de PHP y Node.js
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs
RUN npm ci --prefer-offline --no-audit

# Definir el comando de inicio
CMD ["apache2-foreground"]
