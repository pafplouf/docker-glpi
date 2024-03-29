FROM debian:latest

MAINTAINER P@fpl0uf "mikael.paulhiout@outlook.com"


RUN apt update \
&& apt -y upgrade \
&& apt -y install \
apache2 \
apt-utils \
php \
php-mysql \
php-ldap \
php-xmlrpc \
php-imap \
curl \
php-curl \
php-gd \
php-mbstring \
php-xml \
php-apcu-bc \
php-cas \
php-soap \
cron \
wget \
jq \
nano

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY glpi.sh /opt/
RUN chmod +x /opt/glpi.sh
ENTRYPOINT ["/opt/glpi.sh"]

EXPOSE 80 443