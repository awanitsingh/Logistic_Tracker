# Use official PHP image with Apache
FROM php:8.0-apache

# Install dependencies
RUN apt-get update && apt-get install -y libpq-dev git unzip && docker-php-ext-install pdo pdo_pgsql pgsql

# Set working directory
WORKDIR /var/www/html

# Copy the app files into the container
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies via Composer
RUN composer install --no-dev --optimize-autoloader

# Set the environment variables
COPY .env.example .env

# Run Laravel specific optimizations
RUN php artisan key:generate
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Expose port
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]