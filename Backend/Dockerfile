FROM php:8.3-cli

RUN apt-get update && apt-get install -y \
    git unzip ffmpeg libzip-dev libpng-dev libjpeg-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install pdo_mysql zip gd bcmath exif \
    && rm -rf /var/lib/apt/lists/*

# php artisan serve mặc định chỉ cho upload 2MB, nhạc cần lớn hơn
RUN printf "upload_max_filesize=100M\npost_max_size=100M\nmemory_limit=512M\nmax_execution_time=300\n" \
    > /usr/local/etc/php/conf.d/uploads.ini

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader

COPY . .
RUN composer dump-autoload --optimize

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
