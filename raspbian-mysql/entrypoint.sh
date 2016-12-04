#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- mysqld "$@"
fi

if [ "$1" = 'mysqld' ]; then
    DATADIR="$("$@" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

    if [ ! -d "$DATADIR/mysql" ]; then
        if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" ]; then
            echo >&2 'error: database is uninitialized and MYSQL_ROOT_PASSWORD not set'
            echo >&2 'Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
            exit 1
        fi

        echo 'Initializing database'
        mysql_install_db --datadir="$DATADIR"
        echo 'Database initialized'

        tempSqlFile='/tmp/mysql-first-time.sql'
        echo "DELETE FROM mysql.user ;" >> "$tempSqlFile"
        echo "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;" >> "$tempSqlFile"
        echo "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;" >> "$tempSqlFile"
        echo "DROP DATABASE IF EXISTS test ;" >> "$tempSqlFile"

        if [ "$MYSQL_DATABASE" ]; then
            echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" >> "$tempSqlFile"
        fi

        if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
            echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;" >> "$tmpSqlFile"
            if [ "$MYSQL_DATABASE" ]; then
                echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"
            fi
        fi

        echo 'FLUSH PRIVILEGES ;' >> "$tempSqlFile"

        set -- "$@" --init-file="$tempSqlFile"
    fi

    chown -R mysql:mysql "$DATADIR"
fi

exec "$@"
        
