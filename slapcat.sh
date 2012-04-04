#!/bin/sh -x
set -e
ionice -c2 -n7 -p$$

BACKUP_DIR="$(dirname $0)/dump/slapcat"
umask 027
mkdir -p "$BACKUP_DIR"
umask 077
cd "$BACKUP_DIR"
BACKUP_DIR="$(pwd)"

cd /

for dbnum in 0 1; do
    slapcat -n "$dbnum" -l "$BACKUP_DIR/db$dbnum.$(date +%Y%m%d%H%M%S).ldif"
done
