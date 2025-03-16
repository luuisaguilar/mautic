# Usa una imagen de PHP con Apache
FROM php:8.1-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y curl unzip git nodejs npm yarn \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar variables de entorno para evitar problemas de memoria
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias PHP sin ejecutar scripts automáticos
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs --no-scripts

# Instalar dependencias de frontend
RUN npm install && npm run build || true
RUN yarn install && yarn build || true

# Comando de inicio
CMD ["apache2-foreground"]
