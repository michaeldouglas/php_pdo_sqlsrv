FROM ubuntu:latest

LABEL Michael Araujo (michaeldouglas010790@gmail.com)

#TZ date
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# update package list
RUN apt-get update

# install curl and git
RUN apt install -y curl git

# install Apache
RUN apt install -y apache2 

# install php
RUN apt-get install php7.4 php7.4-dev php7.4-xml php7.4-fpm -y --allow-unauthenticated
RUN apt-get install -y libapache2-mod-php7.4

# Install pdo sqlsrv
RUN apt install -y unixodbc-dev
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
RUN phpenmod -v 7.4 sqlsrv pdo_sqlsrv

# Load Driver
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7.4

EXPOSE 80

WORKDIR /var/www/html/

COPY index.php /var/www/html/
COPY conexao.php /var/www/html/

RUN rm -rf /var/www/html/index.html

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]