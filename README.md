# docker-glpi
## Just a few docker-compose file to deploy GLPI

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
