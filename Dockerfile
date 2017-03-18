FROM jenkins

USER root

RUN wget http://ftp.de.debian.org/debian/pool/main/a/apt/apt-transport-https_1.0.9.8.4_amd64.deb
RUN dpkg -i apt-transport-https_1.0.9.8.4_amd64.deb
RUN wget http://ftp.de.debian.org/debian/pool/main/l/lsb/lsb-release_4.1+Debian13+nmu1_all.deb
RUN dpkg -i lsb-release_4.1+Debian13+nmu1_all.deb

RUN apt-get install apt-transport-https lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt-get update
RUN apt-get install -y --force-yes php7.1-cli php7.1-fpm php7.1-mysql php7.1-pgsql php7.1-sqlite php7.1-curl\
                                   php7.1-gd php7.1-mcrypt php7.1-intl php7.1-imap php7.1-tidy php7.1-apcu php-xdebug\
                                   php7.1-mongo php7.1-xml php7.1-mbstring

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini
RUN sed -i "s/;mbstring.func_overload =.*/mbstring.func_overload = 1/" /etc/php/7.1/cli/php.ini

# build tools
RUN apt-get install -y --force-yes npm nodejs nodejs-legacy
RUN npm install -g grunt-cli
RUN curl -sS https://getcomposer.org/installer | php
RUN chmod +x composer.phar
RUN mv composer.phar /usr/bin
RUN wget https://www.phing.info/get/phing-latest.phar && chmod +x phing-latest.phar && mv phing-latest.phar /usr/bin/phin

USER jenkins
