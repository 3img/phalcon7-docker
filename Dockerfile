FROM php:7.2-fpm-alpine

ENV TIMEZONE Asia/Shanghai
ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M

ADD ./redis-4.2.0 /usr/src/php/ext/redis
ADD ./cphalcon7/ext /usr/src/php/ext/phalcon7

RUN apk --update add tzdata \
   libjpeg-turbo-dev \
	 libpng-dev \
   freetype-dev \
  && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "${TIMEZONE}" > /etc/timezone
  

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-png-dir=/usr --enable-gd-native-ttf --with-jpeg-dir=/usr \
    && docker-php-ext-install phalcon7 redis mysqli gd pdo_mysql redis opcache zip &&\
    sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|" /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    sed -i "s|post_max_size =.*|max_file_uploads = ${PHP_MAX_POST}|" /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini && \
    apk del tzdata curl && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/src/php/ext/redis && \
    rm -rf /usr/src/php/ext/phalcon7

RUN mkdir /www 

WORKDIR /www
VOLUME ["/www"]

EXPOSE 9000
CMD ["php-fpm -F"]
