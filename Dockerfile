FROM wordpress:4.5.3-apache

RUN apt-get update && apt-get install -yqq unzip git

WORKDIR /usr/src/wordpress

RUN curl -o /tmp/composer.phar http://getcomposer.org/composer.phar \
  && mv /tmp/composer.phar /usr/local/bin/composer
RUN curl -o /tmp/markdown.zip https://littoral.michelf.ca/code/php-markdown/php-markdown-extra-1.2.8.zip \
  && unzip /tmp/markdown.zip -d /usr/src/wordpress/wp-content/plugins \
  && mv /usr/src/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/markdown.php /usr/src/wordpress/wp-content/plugins/ \
  && rm -rf /usr/src/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/

RUN curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN cd /tmp && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY etc/.htaccess_extra .
# RUN cat .htaccess_extra >> .htaccess && rm .htaccess_extra && cat .htaccess
RUN cat /entrypoint.sh

RUN sed -i '$ d' /entrypoint.sh
RUN echo 'wp plugin activate dataporten-oauth --allow-root' >> /entrypoint.sh
# RUN echo 'cat .htaccess >> /.htaccess_extra && cat /.htaccess_extra > .htaccess' >> /entrypoint.sh
RUN echo 'exec "$@"' >> /entrypoint.sh

RUN git clone https://github.com/Otto42/simple-twitter-connect.git /usr/share/wordpress/wp-content/plugins/simple-twitter-connect

RUN rm -rf /tmp/stc.zip && rm -rf /tmp/stc && rm -rf /tmp/markdown.zip

COPY etc/composer.json /usr/src/composer.json

RUN chmod a+x /usr/local/bin/composer
RUN cd /usr/src/ && /usr/local/bin/composer install
RUN chmod -R a+rX /usr/src/wordpress

RUN curl -o /tmp/twentyeleven.zip https://downloads.wordpress.org/theme/twentyeleven.2.4.zip
RUN unzip /tmp/twentyeleven.zip -d /usr/src/wordpress/wp-content/themes/
RUN rm -rf /tmp/twentyeleven.zip

COPY www/ /usr/src/wordpress/

RUN ls -la /usr/src/wordpress/
RUN cat /usr/src/wordpress/wp-settings.php

VOLUME /usr/src/wordpress/wp-content/cache
EXPOSE 80
