FROM php:7-fpm-alpine
MAINTAINER Christoph Mueller <christoph@flying-lama.com>

# install system packages
RUN apk --update add \
  autoconf \
  automake \
  bash \
  build-base \
  bzip2 \
  curl \
  cyrus-sasl-dev \
  gcc \
  grep \
  libgsasl-dev \
  libmcrypt-dev \
  libxml2-dev \
  make \
  musl-dev \
  mariadb-client \
  nginx \
  openntpd  \
  openssl  \
  openssl-dev  \
  pkgconfig \
  shadow \
  supervisor \
  vim \
  wget \
  zlib \
  zlib-dev 

# install additional php extensions
RUN docker-php-ext-install \
  bcmath \
  mysqli \
  opcache \
  pdo_mysql

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

# cleanup
RUN rm /var/cache/apk/* && \
    mkdir -p /var/www

# add files
COPY docker-entrypoint.sh /usr/local/bin/
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.0.0/wait /wait
RUN chmod +x /wait

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]