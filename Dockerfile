FROM us.gcr.io/minhamaedizia/magento_base_magento_base
COPY ./etc/php/php.ini /usr/local/etc/php/
COPY ./etc/apache2/conf.d/magento.conf /etc/apache2/sites-available/
RUN a2ensite magento
RUN export PATH=$PATH:/app/bin

ARG MAGENTO_DB_HOST
ARG MAGENTO_DB_NAME
ARG MAGENTO_DB_USER
ARG MAGENTO_DB_PASS

#RUN yes | pecl install xdebug \
#    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_host=10.254.254.254" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/xdebug.ini

#RUN docker-php-ext-install xdebug
WORKDIR /app

RUN php bin/magento setup:install --key="c7ba177b7c2ea1bcde2c8ca65c29027d" --session-save="files" --db-host=${MAGENTO_DB_HOST} --db-name=${MAGENTO_DB_NAME} --db-user=${MAGENTO_DB_USER} --db-password=${MAGENTO_DB_PASS} --base-url="http://minhamaedizia.com.br" --base-url-secure="https://minhamaedizia.com.br" --admin-user="admin" --backend-frontname='admin_1cdhhw' --admin-password="admin123" --admin-email="admin@gmail.com" --admin-firstname="Jose" --admin-lastname="Areas" --currency=BRL --timezone=America/Sao_Paulo --use-rewrites=1

#--language=pt_BR

#RUN php bin/magento indexer:reindex
RUN composer require mageplaza/module-smtp
RUN php bin/magento setup:upgrade

RUN php bin/magento module:enable --all

#RUN php bin/magento setup:upgrade
RUN php bin/magento setup:di:compile
RUN php bin/magento setup:static-content:deploy -f
RUN php bin/magento cache:clean
RUN php bin/magento cache:flush

RUN chmod -R 777 var/
RUN chmod -R 777 app/etc/
RUN chmod -R 777 pub/media/
RUN chmod -R 777 pub/static
RUN chmod -R 777 generated
