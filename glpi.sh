#!/bin/bash

[[ ! "$VERSION_GLPI" ]] \
        && VERSION_GLPI=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/latest | grep tag_name | cut -d '"' -f 4)


SRC_GLPI=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/tags/${VERSION_GLPI} | jq .assets[0].browser_download_url | tr -d \")
TAR_GLPI=$(basename ${SRC_GLPI})
FOLDER_GLPI=glpi/
FOLDER_WEB=/var/www/html/

if !(grep -q "TLS_REQCERT" /etc/ldap/ldap.conf)
then
        echo "TLS_REQCERT isn't present"
        echo -e "TLS_REQCERT\tnever" >> /etc/ldap/ldap.conf
fi

if [ "$(ls ${FOLDER_WEB}${FOLDER_GLPI})" ];
then
        echo "GLPI is already installed"
else
        wget -P ${FOLDER_WEB} ${SRC_GLPI}
        tar -xzf ${FOLDER_WEB}${TAR_GLPI} -C ${FOLDER_WEB}
        rm -Rf ${FOLDER_WEB}${TAR_GLPI}
        chown -R www-data:www-data ${FOLDER_WEB}${FOLDER_GLPI}
fi

echo -e "<VirtualHost *:80>\n\tDocumentRoot /var/www/html/glpi\n\n\t<Directory /var/www/html/glpi>\n\t\tAllowOverride All\n\t\tOrder Allow,Deny\n\t\tAllow from all\n\t</Directory>\n\n\tErrorLog /var/log/apache2/error-glpi.log\n\tLogLevel warn\n\tCustomLog /var/log/apache2/access-glpi.log combined\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

echo "*/2 * * * * www-data /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" >> /etc/cron.d/glpi

service cron start

a2enmod rewrite && service apache2 restart && service apache2 stop

/usr/sbin/apache2ctl -D FOREGROUND
