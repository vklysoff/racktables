FROM alpine:3.15
MAINTAINER Lysov Vitalij

ENV DBHOST="mariadb" \
    DBNAME="racktables" \
    DBUSER="racktables" \
    DBPASS=""

COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /etc/supervisord.conf
RUN apk --no-cache add \
    git \
    ca-certificates \
    curl \
    php7-bcmath \
    php7-curl \
    php7-fpm \
    php7-gd \
    php7-json \
    php7-ldap \
    php7-pcntl \
    php7-pdo_mysql \
    php7-snmp \
    nginx \
    supervisor \
#RUN apk update && apk upgrade && apk --no-cache --update add ca-certificates curl nginx supervisor \
    && chmod +x /entrypoint.sh \
    && mkdir /opt \
    && mkdir /run/nginx \
    && git clone https://github.com/RackTables/racktables/ /opt/racktables \
    && cd /opt/racktables \
    && git checkout RackTables-0.22.0 \
    && sed -i \
    -e 's|^listen =.*$|listen = 9000|' \
    -e 's|^;daemonize =.*$|daemonize = no|' \
    /etc/php7/php-fpm.conf
    #/usr/local/etc/php-fpm.d/www.conf
#
COPY nginx.conf /etc/nginx/nginx.conf
VOLUME /opt/racktables/wwwroot
EXPOSE 9000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
