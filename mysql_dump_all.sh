#!/bin/sh -x
set -e
ionice -c2 -n7 -p$$

BACKUP_DIR="$(dirname $0)/dump/mysqldump"
umask 027
mkdir -p "$BACKUP_DIR"
umask 077

MYSQL_DATABASES=$( find /var/lib/mysql -mindepth 1 -maxdepth 1 -name mysql -prune -o -type d -printf "%f\n" )

# --opt is default after MySQL 5.1
MYSQLDUMP="/usr/bin/mysqldump --defaults-file=/etc/mysql/debian.cnf --opt"

for db_name in $MYSQL_DATABASES; do
    $MYSQLDUMP $db_name | xz >"$BACKUP_DIR/${db_name}.$(date +%Y%m%d%H%M%S).mysqldump.xz"
done
