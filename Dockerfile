FROM ubuntu:latest
MAINTAINER amaljithh@gmail.com

RUN apt-get update && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime &&\
    apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata &&\
    apt-get install -y nginx && apt-get install -y php7.4-fpm

EXPOSE 80

RUN sed -i 's/fastcgi_pass unix:\/var\/run\/php\/php7.4-fpm.sock;/fastcgi_pass unix:\/run\/php\/php7.4-fpm.sock; }/g'\
        /etc/nginx/sites-enabled/default &&\
    sed -i '/fastcgi_pass unix:/s/#//g' /etc/nginx/sites-enabled/default &&\
    sed -i '/.php$ {/s/#//g' /etc/nginx/sites-enabled/default &&\
    sed -i '/fastcgi-php.conf/s/#//g' /etc/nginx/sites-enabled/default &&\
    sed -i 's/index.html/index.php/g' /etc/nginx/sites-enabled/default &&\
    echo "<?php phpinfo();" > /var/www/html/index.php

RUN echo "#!/bin/bash" >> /etc/startup.sh && echo "service nginx start" >> /etc/startup.sh &&\
    echo "service php7.4-fpm start" >> /etc/startup.sh && echo "tail -f /dev/null" >> /etc/startup.sh

ENTRYPOINT ["sh", "/etc/startup.sh"]
