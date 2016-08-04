FROM php:5.6-apache


RUN a2enmod rewrite expires

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev unzip git && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli opcache

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN mkdir -p /app
COPY etc/composer.json /app/
WORKDIR /app


RUN curl -o /tmp/composer.phar http://getcomposer.org/composer.phar \
  && mv /tmp/composer.phar /usr/local/bin/composer && chmod a+x /usr/local/bin/composer
RUN composer install
RUN cp -rT plugins/ wordpress/wp-content/plugins/

RUN curl -o /tmp/markdown.zip https://littoral.michelf.ca/code/php-markdown/php-markdown-extra-1.2.8.zip \
  && unzip /tmp/markdown.zip -d  /app/wordpress/wp-content/plugins \
  && mv  /app/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/markdown.php  /app/wordpress/wp-content/plugins/ \
  && rm -rf  /app/wordpress/wp-content/plugins/PHP\ Markdown\ Extra\ 1.2.8/ \
	&& rm -rf /tmp/markdown.zip

RUN curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN cd /tmp && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# COPY etc/.htaccess_extra .htaccess_extra
# RUN cat .htaccess_extra >> .htaccess && rm .htaccess_extra && cat .htaccess
# RUN cat /entrypoint.sh




#### --- Configure entrypoint ---
COPY bin/entrypoint.sh /entrypoint.sh
# RUN sed -i '$ d' /entrypoint.sh
# RUN echo 'wp plugin activate dataporten-oauth --allow-root' >> /entrypoint.sh
# RUN echo 'cat .htaccess >> /.htaccess_extra && cat /.htaccess_extra > .htaccess' >> /entrypoint.sh
# RUN echo 'exec "$@"' >> /entrypoint.sh


RUN git clone https://github.com/Otto42/simple-twitter-connect.git /app/wordpress/wp-content/plugins/simple-twitter-connect



COPY www/ /app/wordpress

RUN mkdir /app/wordpress/wp-content/uploads
RUN mkdir /app/wordpress/wp-content/cache


RUN chmod 777 /app/wordpress/wp-content/uploads
RUN chmod 777 /app/wordpress/wp-content/cache


# RUN curl -o /tmp/twentyeleven.zip https://downloads.wordpress.org/theme/twentyeleven.2.4.zip
# RUN unzip /tmp/twentyeleven.zip -d /app/wordpress/wp-content/themes/
# RUN rm -rf /tmp/twentyeleven.zip

RUN chmod -R a+rX /app/wordpress
RUN chown -R www-data:www-data /app/wordpress


RUN ls -la /app/wordpress && echo "A"
RUN ls -la /app/ && echo "A"

# RUN cat /usr/src/wordpress/wp-settings.php

VOLUME /app/wordpress/wp-content/cache
EXPOSE 80

COPY etc/apache-vhost.conf /etc/apache2/sites-enabled/000-default.conf
# RUN ls -la /etc/apache2/sites-enabled
# RUN cat /etc/apache2/sites-enabled/000-default.conf


RUN curl -o /app/wordpress/wp-content/themes/feidern/fonts/colfaxLight.woff http://mal.uninett.no/uninett-theme/fonts/colfaxLight.woff
RUN curl -o /app/wordpress/wp-content/themes/feidern/fonts/colfaxMedium.woff http://mal.uninett.no/uninett-theme/fonts/colfaxMedium.woff
RUN curl -o /app/wordpress/wp-content/themes/feidern/fonts/colfaxRegular.woff http://mal.uninett.no/uninett-theme/fonts/colfaxRegular.woff
RUN curl -o /app/wordpress/wp-content/themes/feidern/fonts/colfaxThin.woff http://mal.uninett.no/uninett-theme/fonts/colfaxThin.woff
RUN curl -o /app/wordpress/wp-content/themes/feidern/fonts/colfaxRegularItalic.woff http://mal.uninett.no/uninett-theme/fonts/colfaxRegularItalic.woff

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
