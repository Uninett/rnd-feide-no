FROM wordpress:4.5.3-apache

# ENV PHPREDIS_VERSION 2.2.8
#
# RUN apt-get update && apt-get install -yqq unzip git php5-redis redis-tools
# RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
#     && tar xfz /tmp/redis.tar.gz \
#     && rm -r /tmp/redis.tar.gz \
#     && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
#     && docker-php-ext-install redis
#
# RUN { \
#     echo 'session.save_handler = redis'; \
#     echo 'session.save_path = tcp://redis:6379'; \
# } >> /usr/local/etc/php/conf.d/docker-php-ext-redis.ini

RUN curl -o /tmp/composer.phar http://getcomposer.org/composer.phar \
  && mv /tmp/composer.phar /usr/local/bin/composer
RUN curl -o /tmp/markdown.zip https://littoral.michelf.ca/code/php-markdown/php-markdown-extra-1.2.8.zip \
  && unzip /tmp/markdown.zip -d /usr/src/wordpress/wp-content/plugins \
  && mv /usr/src/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/markdown.php /usr/src/wordpress/wp-content/plugins/ \
  && rm -rf /usr/src/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/


RUN curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN cd /tmp && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

RUN sed -i '$ d' /entrypoint.sh
RUN echo 'wp plugin activate dataporten-oauth --allow-root' >> /entrypoint.sh
RUN echo 'exec "$@"' >> /entrypoint.sh




RUN git clone https://github.com/Otto42/simple-twitter-connect.git /usr/share/wordpress/wp-content/plugins/simple-twitter-connect

RUN rm -rf /tmp/stc.zip && rm -rf /tmp/stc && rm -rf /tmp/markdown.zip

COPY etc/composer.json /usr/src/composer.json

RUN chmod a+x /usr/local/bin/composer
RUN cd /usr/src/ && /usr/local/bin/composer install
RUN chmod -R a+rX /usr/src/wordpress

RUN curl -o /tmp/twentyeleven.zip https://downloads.wordpress.org/theme/twentyeleven.2.4.zip
RUN unzip /tmp/twentyeleven.zip -d /usr/src/wordpress/wp-content/themes/
RUN rm -rf /tmp/twentyeleven.zip && rm -rf /tmp/dataporten-oauth.zip

COPY feidernd /usr/src/wordpress/wp-content/themes/feidernd
# COPY wp-redis-user-session-storage.php /usr/src/wordpress/wp-content/plugins/wp-redis-user-session-storage.php

VOLUME volume/ /var/www/
