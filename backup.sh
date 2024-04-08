#!/bin/bash

mkdir -p /backups

databases=$(docker-compose exec mariadb mysql -e "show databases;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

for db in $databases; do
  docker-compose exec mariadb mysqldump "$db" | gzip > /backups/"$db"_$(date +%Y%m%d%H%M%S).sql.gz
done

# Remove 7 days old files
find /backups -type f -mtime +3 -exec rm {} \;
