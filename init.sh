#!/bin/sh -x
set -e
umask 027
ionice -c2 -n7 -p$$
TOP_DIR="$(dirname $0)"
cd "$TOP_DIR"
TOP_DIR="$(pwd)"
chown root:adm "$TOP_DIR"
chmod 2750 "$TOP_DIR"
chown root:adm *.sh local-dump
chmod 755 *.sh local-dump
cp local-dump /etc/cron.daily/local-dump
chmod 755 /etc/cron.daily/local-dump
mkdir -p mysqldump pg_dump

if [ ! -f /etc/tmpreaper.conf ]; then
    apt-get install tmpreaper
fi
if [ ! -f /etc/tmpreaper.conf ]; then
    echo "/etc/tmpreaper.conf not found" 1>&2
    exit 1
fi
if ! egrep -q "^TMPREAPER_DIRS=.*$TOP_DIR/mysqldump/" /etc/tmpreaper.conf >/dev/null 2>&1; then
    echo 'TMPREAPER_DIRS="$TMPREAPER_DIRS '"$TOP_DIR"'/mysqldump/."' >> /etc/tmpreaper.conf
fi
if ! egrep -q "^TMPREAPER_DIRS=.*$TOP_DIR/pg_dump/" /etc/tmpreaper.conf >/dev/null 2>&1; then
    echo 'TMPREAPER_DIRS="$TMPREAPER_DIRS '"$TOP_DIR"'/pg_dump/."' >> /etc/tmpreaper.conf
fi
