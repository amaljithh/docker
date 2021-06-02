FROM ubuntu:latest
MAINTAINER amaljithh@gmail.com

RUN apt-get update && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime &&\
    apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata &&\
    apt-get install -y nginx && apt-get install -y php7.4-fpm
#CMD service nginx start && service php7.4-fpm start

EXPOSE 80

RUN sed -i 's/fastcgi_pass unix:\/var\/run\/php\/php7.4-fpm.sock;/fastcgi_pass unix:\/run\/php\/php7.4-fpm.sock; }/g'\
        /etc/nginx/sites-enabled/default
RUN sed -i '/fastcgi_pass unix:/s/#//g' /etc/nginx/sites-enabled/default
RUN sed -i '/location ~ \\.php$/s/#//g' /etc/nginx/sites-enabled/default
RUN sed -i 's/index.html/index.php/g' /etc/nginx/sites-enabled/default
RUN touch /var/www/html/index.php
RUN echo "Hello world from php" > /var/www/html/index.php

ENTRYPOINT service php7.4-fpm start
ENTRYPOINT service nginx start
