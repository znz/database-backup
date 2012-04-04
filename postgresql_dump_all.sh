#!/bin/sh -x
set -e
umask 077
ionice -c2 -n7 -p$$

BACKUP_DIR="$(dirname $0)/dump/pg_dump"
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"
BACKUP_DIR="$(pwd)"

cd /

PG_DUMP="/usr/bin/pg_dump -Fc"
PG_DATABASES=$( su postgres -c "psql -c 'SELECT datname FROM pg_database;'" | egrep '^ [^ ]' | egrep -v '^ template[01]$|^ postgres$' )

su postgres -c "psql -l" >"$BACKUP_DIR/psql-l-$(date +%Y%m%d%H%M%S).txt"
for db_name in $PG_DATABASES; do
    su postgres -c "$PG_DUMP $db_name" >"$BACKUP_DIR/${db_name}.$(date +%Y%m%d%H%M%S).pg_dump"
done
