FROM wordpress:4.5.3-apache


RUN apt-get update && apt-get install -yqq unzip git

RUN curl -o /tmp/composer.phar http://getcomposer.org/composer.phar \
  && mv /tmp/composer.phar /usr/local/bin/composer
RUN curl -o /tmp/markdown.zip https://littoral.michelf.ca/code/php-markdown/php-markdown-extra-1.2.8.zip \
  && unzip /tmp/markdown.zip -d /usr/src/wordpress/wp-content/plugins \
  && mv /usr/src/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/markdown.php /usr/src/wordpress/wp-content/plugins/ \
  && rm -rf /usr/src/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/


RUN curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN cd /tmp && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY etc/.htaccess_extra /.htaccess_extra

RUN sed -i '$ d' /entrypoint.sh
RUN echo 'wp plugin activate dataporten-oauth --allow-root' >> /entrypoint.sh
RUN echo 'cat .htaccess >> /.htaccess_extra && cat /.htaccess_extra > .htaccess' >> /entrypoint.sh
RUN echo 'exec "$@"' >> /entrypoint.sh


RUN git clone https://github.com/Otto42/simple-twitter-connect.git /usr/share/wordpress/wp-content/plugins/simple-twitter-connect

RUN rm -rf /tmp/stc.zip && rm -rf /tmp/stc && rm -rf /tmp/markdown.zip

ADD etc/composer.json /usr/src/composer.json

RUN chmod a+x /usr/local/bin/composer
RUN cd /usr/src/ && /usr/local/bin/composer install
RUN chmod -R a+rX /usr/src/wordpress

RUN curl -o /tmp/twentyeleven.zip https://downloads.wordpress.org/theme/twentyeleven.2.4.zip
RUN unzip /tmp/twentyeleven.zip -d /usr/src/wordpress/wp-content/themes/
RUN rm -rf /tmp/twentyeleven.zip && rm -rf /tmp/dataporten-oauth.zip
RUN echo "ok" > /usr/src/wordpress/ok.html

COPY feidernd /usr/src/wordpress/wp-content/themes/feidernd
COPY etc/env_lister.php /usr/src/wordpress/version/index.php

VOLUME volume/ /var/www/
