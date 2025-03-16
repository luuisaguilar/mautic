# Usa una imagen de PHP con Apache
FROM php:8.1-apache

# Instalar dependencias necesarias con versiones compatibles
RUN apt-get update && apt-get install -y \
    curl unzip git nodejs npm yarn \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev=1.5.1-0ubuntu1 libxml2-dev mariadb-client \
    && docker-php-ext-configure zip --with-libzip=/usr/include \
    && docker-php-ext-install pdo pdo_mysql gd mbstring xml zip


# Configurar variables de entorno para evitar problemas de memoria
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto
COPY . .

# Configurar permisos adecuados para los directorios de Mautic
RUN mkdir -p var/cache var/logs var/sessions && \
    chmod -R 777 var/cache var/logs var/sessions && \
    chown -R www-data:www-data var/cache var/logs var/sessions

# Instalar dependencias PHP sin ejecutar scripts automáticos
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs --no-scripts

# Instalar dependencias de frontend
RUN npm install && npm run build || true
RUN yarn install && yarn build || true

# Configurar el ServerName para evitar advertencias de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Definir el comando de inicio
CMD ["apache2-foreground"]
