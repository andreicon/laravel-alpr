FROM ubuntu:16.04

MAINTAINER Andrei Costea <andrei.costea47@gmail.com>

RUN apt update && apt install -y \
 curl git openssh-server openssh-client openssl nano \
 php php-bcmath php-dom php-ctype php-curl php-fpm php-gd php-iconv php-intl php-json php-mbstring php-mcrypt php-mysqlnd php-opcache php-pdo php-phar php-posix php-soap php-xml php-zip \
 openalpr openalpr-daemon openalpr-utils libopenalpr-dev tesseract-ocr

# ------------------------------------------------------------------------------
# Some PHP tweaks
# ------------------------------------------------------------------------------

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
		&& echo "date.timezone=${PHP_TIMEZONE:-UTC}" > "$PHP_INI_DIR/conf.d/date_timezone.ini"

# ------------------------------------------------------------------------------
# Get Composer
# ------------------------------------------------------------------------------

ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 1.3.2

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/5fd32f776359b8714e2647ab4cd8a7bed5f3714d/web/installer \
 && php -r " \
	\$signature = '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30'; \
	\$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
	if (!hash_equals(\$signature, \$hash)) { \
    	unlink('/tmp/installer.php'); \
    	echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
    	exit(1); \
	}" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && rm /tmp/installer.php \
 && composer --ansi --version --no-interaction

# ------------------------------------------------------------------------------
# Create laravel project in /laravel, switch dir and run the development server
# on port 8000 (remember to expose this port with -p 8000:8000 or -P)
# At this point it could be useful to set 
# ENV COMPOSER_AUTH='{"github.com": "oauthtoken"}'
# to avoid hitting the rate limit
# ------------------------------------------------------------------------------

RUN composer create-project --prefer-dist laravel/laravel laravel

WORKDIR /laravel
# ------------------------------------------------------------------------------
# Copy our app specific files
# ------------------------------------------------------------------------------
COPY config /laravel/config
COPY app /laravel/app
COPY routes /laravel/routes
COPY resources /laravel/resources
COPY composer.json /laravel/composer.json

# ------------------------------------------------------------------------------
# Install composer deps
# ------------------------------------------------------------------------------

RUN composer update
RUN php artisan storage:link

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port", "8000"]