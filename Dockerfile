FROM wordpress:latest


RUN apt-get update && apt-get install -yqq unzip
RUN curl -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN cd /tmp && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

RUN curl -o /tmp/dataporten-oauth.zip https://downloads.wordpress.org/plugin/dataporten-oauth.1.2.zip
RUN curl -o /tmp/twentyeleven.zip https://downloads.wordpress.org/theme/twentyeleven.2.4.zip
RUN unzip /tmp/dataporten-oauth.zip -d /usr/src/wordpress/wp-content/plugins/
RUN unzip /tmp/twentyeleven.zip -d /usr/src/wordpress/wp-content/themes/
RUN rm -rf /tmp/twentyeleven.zip && rm -rf /tmp/dataporten-oauth.zip

COPY rnd.extras.tar.gz /tmp/rnd.extras.tar.gz
COPY rnd.plugins.tar.gz /tmp/rnd.plugins.tar.gz
COPY feidernd /usr/src/wordpress/wp-content/themes/feidernd
RUN tar xzvf /tmp/rnd.extras.tar.gz -C /var/www
RUN tar xzvf /tmp/rnd.plugins.tar.gz -C /usr/src/wordpress/wp-content/
RUN rm /tmp/rnd.plugins.tar.gz
RUN rm /tmp/rnd.extras.tar.gz

VOLUME volume/ /var/www/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
