# Usa una imagen de PHP con Composer ya instalado
FROM php:8.1-cli

# Instala Composer manualmente si la imagen base no lo incluye
RUN apt-get update && apt-get install -y curl unzip git \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Asegura la memoria para PHP y Composer
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1

# Copia el código fuente
WORKDIR /app
COPY . .

# Instala dependencias
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Comando por defecto
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
