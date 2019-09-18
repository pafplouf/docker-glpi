# docker-glpi
## Just few configuration file to deploy GLPI
### docker-compose.yaml :

    version: "3.2"

    services:
      sql:
        image: mariadb:latest
        container_name: sql
        volumes:
          - mariadb:/var/lib/mysql
        env_file:
          - ./mysql.env
        restart: always
        networks:
          - glpinetwork

      glpi:
        image: pafplouf/glpi:latest
        container_name : glpi
        ports:
          - "80:80"
        volumes:
          - ./glpi:/var/www/html/glpi
        depends_on:
          - sql
        restart: always
        networks:
          - glpinetwork
    networks:
      glpinetwork:

    volumes:
      mariadb:

### mysql.env :
    MYSQL_ROOT_PASSWORD=root
    MYSQL_DATABASE=glpidb
    MYSQL_USER=glpi_user
    MYSQL_PASSWORD=glpi
